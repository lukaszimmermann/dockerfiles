.PHONY: init_sso_volume check-env

# Inits the Volume for the Arvados SSO server
init_sso_volume: check-env
	docker volume create arvados_sso_pg_11
	docker build --no-cache --pull --rm -t arvados_sso_pg:11  arvados-volume-sso
	docker run --rm -v arvados_sso_pg_11:/tmp/volume arvados_sso_pg:11


check-env:
ifndef SSO_PASSWORD
  $(error SSO_PASSWORD is undefined)
endif
