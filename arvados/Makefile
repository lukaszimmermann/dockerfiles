.PHONY: init_sso_volume

# Inits the Volume for the Arvados SSO server
init_sso_volume:
	docker volume create arvados_sso_pg_11
	docker build --build-arg PG_PASSWORD=${PG_PASSWORD} --no-cache --rm -t arvados_sso_pg:11  arvados-volume-sso
	docker run --rm -v arvados_sso_pg_11:/tmp/volume arvados_sso_pg:11

