#!/usr/bin/env bash
set -e


##############################################################################
# Function for checking environment variables
##############################################################################
check_variable() {

if [ -z ${$1+x} ]; then

cat << EOF
    #############################################################################
    FATAL ERROR: Variable $1 is unset. This is not supported.
                 $3
    #############################################################################
EOF
     exit "$2"
fi
}


##############################################################################
# Check the existence of certain environment variables
##############################################################################
# ARV_UUID_PREFIX
check_variable 'ARV_UUID_PREFIX' 1

# PG_HOST
check_variable 'PG_HOST' 2 'The value should be something like postgres:5432'

# PG_PASSWORD
check_variable 'PG_PASSWORD' 3 \
  'The value is the password for the arvados_sso user'


##############################################################################
# Wait for the Postgres Database to come up
##############################################################################
wait-for-it.sh "${PG_HOST}"


##############################################################################
# Generate the secret token
##############################################################################
ARV_SECRET_TOKEN="$(ruby -e 'puts rand(2**400).to_s(36)')"


##############################################################################
# Set up the application.yml
##############################################################################
cat >/etc/arvados/sso/application.yml <<-EOF
# Copy this file to application.yml and edit to suit.
#
# Consult application.default.yml for the full list of configuration
# settings.
#
# The order of precedence is:
# 1. config/environments/{RAILS_ENV}.rb (deprecated)
# 2. Section in application.yml corresponding to RAILS_ENV (e.g., development)
# 3. Section in application.yml called "common"
# 4. Section in application.default.yml corresponding to RAILS_ENV
# 5. Section in application.default.yml called "common"

common:
  uuid_prefix: ${ARV_UUID_PREFIX}
  secret_token: ${ARV_SECRET_TOKEN}

  # The site name that will be used in text such as "Sign in to site_title"
  site_title: Arvados

  # After logging in, the title and URL of the link that will be presented to
  # the user as the default destination on the welcome page.
  default_link_title: Arvados
  default_link_url: "http://localhost:3000"

  ###
  ### Local account configuration.  This is enabled if neither
  ### google_oauth2 or LDAP are enabled below.
  ###
  # If true, allow new creation of new accounts in the SSO server's internal
  # user database.
  allow_account_registration: false

  # If true, send an email confirmation before activating new accounts in the
  # SSO server's internal user database.
  require_email_confirmation: false


  ###
  ### Google+ OAuth2 authentication.
  ###
  # Google API tokens required for OAuth2 login.
  #
  # See https://github.com/zquestz/omniauth-google-oauth2
  #
  # and https://developers.google.com/accounts/docs/OAuth2
  google_oauth2_client_id: false
  google_oauth2_client_secret: false

  # Set this to your OpenId 2.0 realm to enable migration from Google OpenId
  # 2.0 to Google OAuth2 OpenId Connect (Google will provide OpenId 2.0 user
  # identifiers via the openid.realm parameter in the OAuth2 flow until 2017).
  google_openid_realm: false


  ###
  ### LDAP authentication.
  ###
  #
  # If you want to use LDAP, you need to provide
  # the following set of fields under the use_ldap key.
  #
  # If 'email_domain' field is set, it will be stripped from the email address
  # entered by the user prior attempting LDAP binding on 'uid'.  This supports
  # the case where it is not possible to look up 'bob@example.com' but instead
  # must be looked up as 'uid=bob'.
  #
  # If it is possible to look up the email address directly (for example
  # setting "uid: mail") you should prefer that and leave 'email_domain' unset.
  #
  # If 'username' is set, this specifies the LDAP field that will be propagated
  # to the "username" field in the users table.  This should be a
  # posix-compatible username (which may be different from the username part of
  # the email address.)
  #
  # Provide 'bind_dn' and 'password' if your LDAP server requires
  # a login before authenticating a user.
  #
  # use_ldap:
  #   title: Example LDAP
  #   host: ldap.example.com
  #   port: 636
  #   method: ssl
  #   base: "ou=Users, dc=example, dc=com"
  #   uid: uid
  #   username: uid
  #   #email_domain: example.com
  #   #bind_dn: "some_user"
  #   #password: "some_password"
  #
  use_ldap: false
EOF
sync


##############################################################################
# Set up the database.yml
##############################################################################
cat >/etc/arvados/sso/database.yml <<-EOF
production:
  adapter: postgresql
  encoding: utf8
  database: arvados_sso_production
  username: arvados_sso
  password: ${PG_PASSWORD}
  host: localhost
  template: template0
EOF
sync

##############################################################################
# Reconfigure the Arvados SSO server
##############################################################################
dpkg-reconfigure arvados-sso-server


##############################################################################
# Cleanup
##############################################################################
unset ARV_UUID_PREFIX
unset ARV_SECRET_TOKEN
