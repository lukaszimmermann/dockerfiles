package main

import (
	"archive/tar"
	"bufio"
	"compress/gzip"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"sort"
	"strings"
)

const (
	GE  = ">="
	GT  = ">"
	EQ  = "="
	LT  = "<"
	PKGNAME = "%NAME%"
	PKGDEPENDS = "%DEPENDS%"
	PKGPROVIDES = "%PROVIDES%"
	PKGPREFIX = "%"
	CORE = "core"
	EXTRA = "extra"
	COMMUNITY = "community"
	PAC1 = "/var/lib/pacman/sync/core.db"
	PAC2 = "/var/lib/pacman/sync/extra.db"
	PAC3 = "/var/lib/pacman/sync/community.db"
	AUR_TOKEN = "AUR"
)
var separators = []string {GE, GT, EQ, LT}
var pacfiles = [][]string {
	{PAC1, CORE},
	{PAC2, EXTRA},
	{PAC3, COMMUNITY},
}


// Interface for representing packages
type Package interface {
	 Name() string
	 Repository() string
	 Dependencies() []Package
}

type pkg struct {
	mName string
	mRepo string
	mDep func() []Package
}

func (pkg *pkg) Name() string {
	return pkg.mName
}

func (pkg *pkg) Repository() string {
	return pkg.mRepo
}

func (pkg *pkg) Dependencies() []Package {
	return pkg.mDep()
}



func handleErr(err error) {
	if err != nil {
		log.Fatal(err)
	}
}

func readPackages(filePath string) map[string]bool {
	result := make(map[string]bool)
	file, err := os.Open(filePath)
	handleErr(err)
	defer file.Close()
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		text := strings.TrimSpace(scanner.Text())
		if len(text) > 0 {
			result[text] = true
		}
	}
	return result
}

type ParseState int
const (
	NONE ParseState = iota
	NAME
	DEPENDS
	PROVIDES
)

func simplePackageName(name string) string {

	// Remove so suffix
	if strings.HasSuffix(name, ".so") {
		name = name[:len(name)-3]
	}
	// Split version requirement separators
	for _, sep := range separators {
		if strings.Contains(name, sep) {
			return strings.Split(name, sep)[0]
		}
	}
	return name
}

type PackageFactory struct {
	init bool
	providers map[string][]string
	packages map[string]bool
	repos map[string]string
	dependencies map[string][]string
}

func (ana *PackageFactory) parse(srcFile string, repo string) {
	f, err := os.Open(srcFile)
	handleErr(err)
	defer f.Close()

	gzf, err := gzip.NewReader(f)
	handleErr(err)
	tarReader := tar.NewReader(gzf)
	if ! ana.init {
		ana.providers = make(map[string][]string)
		ana.dependencies = make(map[string][]string)
		ana.packages = make(map[string]bool)
		ana.repos = make(map[string]string)
		ana.init = true
	}
	for {
		header, err := tarReader.Next()
		if err == io.EOF {
			break
		}
		handleErr(err)

		switch header.Typeflag {
		case tar.TypeDir:
			continue
		case tar.TypeReg:
			all, err := ioutil.ReadAll(tarReader)
			handleErr(err)
			state := NONE
			var name string
			var depends []string
			var provides []string

			lines := strings.Split(string(all), "\n")
			for _, line := range lines {
				if line = strings.TrimSpace(line); len(line) > 0 {
					if strings.Contains(line, PKGNAME) {
						state = NAME
					} else if strings.Contains(line, PKGDEPENDS) {
						state = DEPENDS
					} else if strings.Contains(line, PKGPROVIDES) {
					    state = PROVIDES
					} else if strings.HasPrefix(line, PKGPREFIX) {
						state = NONE
					} else if state == DEPENDS {
						pkg := simplePackageName(line)
						depends = append(depends, pkg)
					} else if state == PROVIDES {
						pkg := simplePackageName(line)
						provides = append(provides, pkg)
					}else if state == NAME {
						pkg := simplePackageName(line)
						ana.packages[pkg] = true
						name = pkg
					}
				}
			}
			ana.dependencies[name] = depends
			ana.repos[name] = repo
			for _, provide := range provides {
				if providers, ok := ana.providers[provide]; ok {
					ana.providers[provide] = append(providers, name)
				} else {
					ana.providers[provide] = []string {name}
				}
			}
		default:
			log.Fatal("Unknown header type")
		}
	}
}


type aurpackage struct {
	Name string `json:"Name"`
	Depends []string `json:"Depends"`
	MakeDepends []string `json:"MakeDepends"`
	OptDepends []string `json:"OptDepends"`
}


type aurresponse struct {
	Results []aurpackage `json:"results"`
}

func getAurDepends(pkg string) ([]string, bool) {
	resp, err := http.Get(fmt.Sprintf("https://aur.archlinux.org/rpc/?v=5&type=info&arg[]=%s", pkg))
	handleErr(err)
	if resp.StatusCode != http.StatusOK {
		return nil, false
	}
	var aur aurresponse
	err = json.NewDecoder(resp.Body).Decode(&aur)
	handleErr(err)
	results := aur.Results
	if len(results) == 0 {
		return nil, false
	}

	if len(results) > 1 {
		panic("Too many results!")
	}
	result := results[0]
	all_depends := append(result.Depends, result.OptDepends...)
	all_depends = append(all_depends, result.MakeDepends...)
	return all_depends, true
}


func (ana *PackageFactory) newPackage(name string) Package {

	name = simplePackageName(name)

	// Regular package
	if _, ok := ana.packages[name]; ok {
		return &pkg{
			mName: name,
			mRepo: ana.repos[name],
			mDep:  func() []Package {

				var result []Package
				if deps, ok := ana.dependencies[name]; ok {
					for _, dep := range deps {
						result = append(result, ana.newPackage(dep))
					}
				}
				return result
			},
		}
	}

	// Aur Package
	depends, ok := getAurDepends(name)
	if ok {
		return &pkg{
			mName: name,
			mRepo: AUR_TOKEN,
			mDep:  func() []Package {
				var result []Package
				for _, dep := range depends {
					result = append(result, ana.newPackage(dep))
				}
				return result
			},
		}
	}
	// Single Provider
	if providers, ok := ana.providers[name]; ok && len(providers) == 1 {
		name = providers[0]
		return &pkg{
			mName: name,
			mRepo: ana.repos[name],
			mDep:  func() []Package {

				var result []Package
				if deps, ok := ana.dependencies[name]; ok {
					for _, dep := range deps {
						result = append(result, ana.newPackage(dep))
					}
				}
				return result
			},
		}
	}
	return nil
}


func expand(pkg Package) chan Package {
	ch := make(chan Package)
	seen := make(map[string]bool)

	var recurse func(Package, bool)
	recurse = func(pkg Package, top bool) {
		if pkg != nil {
			name := pkg.Name()
			if _, ok := seen[name]; !ok {
				seen[name] = true
				ch <- pkg
				if pkg.Repository() == AUR_TOKEN {
					for _, dep := range pkg.Dependencies() {
						recurse(dep, false)
					}
				}
			}
		}
		if top {
			close(ch)
		}
	}
	go recurse(pkg, true)
	return ch
}


func main() {

	if len(os.Args) != 2 {
		log.Fatal("Wrong number of parameters")
	}
	ana := PackageFactory{}
	for _, pac := range pacfiles {
		ana.parse(pac[0], pac[1])
	}
	packages := readPackages(os.Args[1])

	elements := make(map[string]bool)
	for pkgName, _ := range packages {
		pkg := ana.newPackage(pkgName)
		for dep := range expand(pkg) {
			if dep != nil {
				elements[dep.Name()] = true
			}
		}
	}
	var result []string
	for key, _ := range elements {
		result = append(result, key)
	}
	sort.Strings(result)

	for _, pkg := range result {
		fmt.Println(pkg)
	}
}
