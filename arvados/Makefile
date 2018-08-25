.PHONY: init_sso_volume

# Inits the Volume for the Arvados SSO server
init_sso_volume:
	docker volume create arvados_sso_pg_10
	docker build --no-cache --rm -t arvados_sso_pg:10  arvados-volume-sso
	docker run --rm -v arvados_sso_pg_10:/tmp/volume arvados_sso_pg:10

