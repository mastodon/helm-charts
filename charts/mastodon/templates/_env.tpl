{{/*
Helper templates for building environment configmaps and secrets.
*/}}

{{/*
Mastodon general info.
*/}}
{{- define "mastodon.env" -}}
{{- if .Values.timezone }}
TZ: {{ .Values.timezone | quote }}
{{- end }}
{{- with .Values.mastodon }}
LOCAL_DOMAIN: {{ .local_domain | quote }}
{{- if .web_domain }}
WEB_DOMAIN: {{ .web_domain | quote }}
{{- end }}
{{- if .locale }}
DEFAULT_LOCALE: {{ .locale | quote }}
{{- end }}
{{- if .alternate_domains }}
ALTERNATE_DOMAINS: {{ join "," .alternate_domains | quote }}
{{- end }}
{{- if .singleUserMode }}
SINGLE_USER_MODE: "true"
{{- end }}
{{- if .authorizedFetch }}
AUTHORIZED_FETCH: {{ .authorizedFetch | quote }}
{{- end }}
{{- if .limitedFederationMode }}
LIMITED_FEDERATION_MODE: {{ .limitedFederationMode | quote }}
{{- end }}
MALLOC_ARENA_MAX: "2"
NODE_ENV: "production"
RAILS_ENV: "production"
STREAMING_CLUSTER_NUM: {{ .streaming.workers | quote }}
{{- if .streaming.baseUrl }}
STREAMING_API_BASE_URL: {{ .streaming.baseUrl | quote }}
{{- end }}
{{- if .trustedProxyIp }}
TRUSTED_PROXY_IP: {{ .trustedProxyIp | quote }}
{{- end }}
{{- if .deepl.enabled }}
DEEPL_PLAN: {{ .deepl.plan | quote }}
{{- end }}
{{- if .hcaptcha.enabled | quote }}
HCAPTCHA_SITE_KEY: {{ .hcaptcha.siteId| quote }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Mastodon secret definitions
*/}}
{{- define "mastodon.env.secrets" -}}
{{- with .Values.mastodon.secrets -}}
SECRET_KEY_BASE: {{ required "secretKeyBase is required" (.secretKeyBase | b64enc | quote) }}
VAPID_PRIVATE_KEY: {{ required "vapidPrivateKey is required" (.vapidPrivateKey | b64enc | quote) }}
VAPID_PUBLIC_KEY: {{ required "vapidPublicKey is required" (.vapidPublicKey | b64enc | quote) }}
ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY: {{ required "arPrimaryKey is required" (.arPrimaryKey | b64enc | quote) }}
ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY: {{ required "arDeterministicKey is required" (.arDeterministicKey | b64enc | quote) }}
ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT: {{ required "arKeyDerivationSalt is required" (.arKeyDerivationSalt | b64enc | quote) }}
{{- end }}
{{- end }}

{{/*
Database info.
*/}}
{{- define "mastodon.env.database" -}}
{{- with .Values.postgresql -}}
DB_HOST: {{ required "Database hostname must be given" .hostname | quote }}
DB_PORT: {{ required "Database port must be given" .port | quote }}
DB_NAME: {{ required "Database name must be given" .database | quote }}
PREPARED_STATEMENTS: {{ .preparedStatements | quote }}
{{- end }}
{{- end }}

{{/*
Database direct connection info.
Will render out just the same as the normal connection info if direct values are
not given.
*/}}
{{- define "mastodon.env.database.direct" -}}
{{- with .Values.postgresql -}}
DB_HOST: {{ coalesce .direct.hostname .hostname | quote }}
DB_PORT: {{ coalesce .direct.port .port | quote }}
DB_NAME: {{ coalesce .direct.database .database | quote }}
PREPARED_STATEMENTS: {{ .preparedStatements | quote }}
{{- end }}
{{- end }}

{{/*
Database replica connection info.
*/}}
{{- define "mastodon.env.database.replica" -}}
{{- with .Values.postgresql.readReplica -}}
{{- if .hostname }}
REPLICA_DB_HOST: {{ .hostname | quote }}
{{- end }}
{{- if .port }}
REPLICA_DB_PORT: {{ .port | quote }}
{{- end }}
{{- if .database }}
REPLICA_DB_NAME: {{ .database | quote }}
{{- end }}
{{- if .username }}
REPLICA_DB_USER: {{ .username | quote }}
{{- end }}
{{- if .password }}
REPLICA_DB_PASS: {{ .password | quote }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Elasticsearch info.
*/}}
{{- define "mastodon.env.elasticsearch" -}}
{{- with .Values.elasticsearch -}}
{{- if .enabled }}
ES_ENABLED: "true"
ES_HOST: {{ required "Elasticsearch hostname is required" .hostname | quote }}
{{- if .preset }}
ES_PRESET: {{ .preset | quote }}
{{- end }}
{{- if .port }}
ES_PORT: {{ .port | quote }}
{{- end }}
{{- else }}
ES_ENABLED: "false"
{{- end }}
{{- end }}
{{- end }}

{{/*
Redis info.
*/}}
{{- define "mastodon.env.redis" -}}
{{- with .Values.redis -}}
REDIS_HOST: {{ required "Redis hostname is required" .hostname | quote }}
{{- if .port }}
REDIS_PORT: {{ .port | quote }}
{{- end }}
{{- if .sidekiq.enabled }}
SIDEKIQ_REDIS_HOST: {{ required "Redis sidekiq hostname is required when enabled" .sidekiq.hostname | quote }}
{{- if .sidekiq.port }}
SIDEKIQ_REDIS_PORT: {{ .sidekiq.port | quote }}
{{- end }}
{{- end }}
{{- if .cache.enabled }}
CACHE_REDIS_HOST: {{ required "Redis cache hostname is required when enabled" .cache.hostname | quote }}
{{- if .cache.port }}
CACHE_REDIS_PORT: {{ .cache.port | quote }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
S3 info.
*/}}
{{- define "mastodon.env.s3" -}}
{{- with .Values.mastodon.s3 -}}
S3_ENABLED: "true"
S3_BUCKET: {{ required "S3 bucket is required" .bucket | quote }}
S3_ENDPOINT: {{ required "S3 endpoint is required" .endpoint | quote }}
S3_HOSTNAME: {{ required "S3 hostname is required" .hostname | quote}}
S3_PROTOCOL: "https"
{{- if .permission }}
S3_PERMISSION: {{ .permission | quote }}
{{- end }}
{{- if .region }}
S3_REGION: {{ .region | quote }}
{{- end }}
{{- if .alias_host }}
S3_ALIAS_HOST: {{ .alias_host | quote }}
{{- end }}
{{- if .multipart_threshold }}
S3_MULTIPART_THRESHOLD: {{ .multipart_threshold | quote }}
{{- end }}
{{- if .override_path_style }}
S3_OVERRIDE_PATH_STYLE: {{ .override_path_style | quote }}
{{- end }}
{{- end }}
{{- end }}

{{/*
SMTP info.
*/}}
{{- define "mastodon.env.smtp" -}}
{{- with .Values.mastodon.smtp -}}
{{- if .auth_method }}
SMTP_AUTH_METHOD: {{ .auth_method | quote }}
{{- end }}
{{- if .ca_file }}
SMTP_CA_FILE: {{ .ca_file | quote }}
{{- end }}
{{- if .delivery_method }}
SMTP_DELIVERY_METHOD: {{ .delivery_method | quote }}
{{- end }}
{{- if .domain }}
SMTP_DOMAIN: {{ .domain | quote }}
{{- end }}
{{- if .enable_starttls }}
SMTP_ENABLE_STARTTLS: {{ .enable_starttls | quote }}
{{- end }}
{{- if .enable_starttls_auto }}
SMTP_ENABLE_STARTTLS_AUTO: {{ .enable_starttls_auto | quote }}
{{- end }}
{{- if .from_address }}
SMTP_FROM_ADDRESS: {{ .from_address | quote }}
{{- end }}
{{- if .return_path }}
SMTP_RETURN_PATH: {{ .return_path | quote }}
{{- end }}
{{- if .openssl_verify_mode }}
SMTP_OPENSSL_VERIFY_MODE: {{ .openssl_verify_mode | quote }}
{{- end }}
{{- if .port }}
SMTP_PORT: {{ .port | quote }}
{{- end }}
{{- if .replyTo }}
SMTP_REPLY_TO: {{ .replyTo | quote }}
{{- end }}
{{- if .server }}
SMTP_SERVER: {{ .server | quote }}
{{- end }}
{{- if .tls }}
SMTP_TLS: {{ .tls | quote }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Bulk SMTP info.
Renders blank if not enabled.
*/}}
{{- define "mastodon.env.smtp.bulk" -}}
{{- with .Values.mastodon.smtp.bulk -}}
{{- if .auth_method }}
BULK_SMTP_AUTH_METHOD: {{ .auth_method }}
{{- end }}
{{- if .ca_file }}
BULK_SMTP_CA_FILE: {{ .ca_file }}
{{- end }}
{{- if .domain }}
BULK_SMTP_DOMAIN: {{ .domain }}
{{- end }}
{{- if .enable_starttls }}
BULK_SMTP_ENABLE_STARTTLS: {{ .enable_starttls | quote }}
{{- end }}
{{- if .enable_starttls_auto }}
BULK_SMTP_ENABLE_STARTTLS_AUTO: {{ .enable_starttls_auto | quote }}
{{- end }}
{{- if .from_address }}
BULK_SMTP_FROM_ADDRESS: {{ .from_address | quote }}
{{- end }}
{{- if .openssl_verify_mode }}
BULK_SMTP_OPENSSL_VERIFY_MODE: {{ .openssl_verify_mode }}
{{- end }}
{{- if .port }}
BULK_SMTP_PORT: {{ .port | quote }}
{{- end }}
{{- if .server }}
BULK_SMTP_SERVER: {{ .server }}
{{- end }}
{{- if .tls }}
BULK_SMTP_TLS: {{ .tls | quote }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Cache Buster info
*/}}
{{- define "mastodon.env.cacheBuster" -}}
{{- with .Values.mastodon.cacheBuster -}}
{{- if .enabled }}
CACHE_BUSTER_ENABLED: "true"
{{- if .httpMethod }}
CACHE_BUSTER_HTTP_METHOD: {{ .httpMethod }}
{{- end }}
{{- if .authHeader }}
CACHE_BUSTER_SECRET_HEADER: {{ .authHeader }}
{{- end }}
{{- else }}
CACHE_BUSTER_ENABLED: "false"
{{- end }}
{{- end }}
{{- end }}

{{/*
OIDC login info.
Renders blank if not enabled.
*/}}
{{- define "mastodon.env.auth.oidc" -}}
{{- with .Values.externalAuth.oidc -}}
{{- if .enabled }}
OIDC_ENABLED: "true"
OIDC_DISPLAY_NAME: {{ .displayName | quote }}
OIDC_ISSUER: {{ .issuer | quote }}
OIDC_DISCOVERY: {{ .discovery | quote }}
OIDC_SCOPE: {{ .scope | quote }}
OIDC_UID_FIELD: {{ .uidField | quote }}
OIDC_CLIENT_ID: {{ .clientId | quote }}
OIDC_CLIENT_SECRET: {{ .clientSecret | quote }}
OIDC_REDIRECT_URI: {{ .redirectUri | quote }}
OIDC_SECURITY_ASSUME_EMAIL_IS_VERIFIED: {{ .assumeEmailIsVerified | quote }}
{{- if .clientAuthMethod }}
OIDC_CLIENT_AUTH_METHOD: {{ .clientAuthMethod | quote }}
{{- end }}
{{- if .responseType }}
OIDC_RESPONSE_TYPE: {{ .responseType | quote }}
{{- end }}
{{- if .responseMode }}
OIDC_RESPONSE_MODE: {{ .responseMode | quote }}
{{- end }}
{{- if .display }}
OIDC_DISPLAY: {{ .display | quote }}
{{- end }}
{{- if .prompt }}
OIDC_PROMPT: {{ .prompt | quote }}
{{- end }}
{{- if .sendNonce }}
OIDC_SEND_NONCE: {{ .sendNonce | quote }}
{{- end }}
{{- if .sendScopeToTokenEndpoint }}
OIDC_SEND_SCOPE_TO_TOKEN_ENDPOINT: {{ .sendScopeToTokenEndpoint | quote }}
{{- end }}
{{- if .idpLogoutRedirectUri }}
OIDC_IDP_LOGOUT_REDIRECT_URI: {{ .idpLogoutRedirectUri | quote }}
{{- end }}
{{- if .httpScheme }}
OIDC_HTTP_SCHEME: {{ .httpScheme | quote }}
{{- end }}
{{- if .host }}
OIDC_HOST: {{ .host | quote }}
{{- end }}
{{- if .port }}
OIDC_PORT: {{ .port | quote }}
{{- end }}
{{- if .jwksUri }}
OIDC_JWKS_URI: {{ .jwksUri | quote }}
{{- end }}
{{- if .authEndpoint }}
OIDC_AUTH_ENDPOINT: {{ .authEndpoint | quote }}
{{- end }}
{{- if .tokenEndpoint }}
OIDC_TOKEN_ENDPOINT: {{ .tokenEndpoint | quote }}
{{- end }}
{{- if .userInfoEndpoint }}
OIDC_USER_INFO_ENDPOINT: {{ .userInfoEndpoint | quote }}
{{- end }}
{{- if .endSessionEndpoint }}
OIDC_END_SESSION_ENDPOINT: {{ .endSessionEndpoint | quote }}
{{- end }}
{{- else }}
OIDC_ENABLED: "false"
{{- end }}
{{- end }}
{{- end }}

{{/*
SAML login info.
*/}}
{{- define "mastodon.env.auth.saml" -}}
{{- with .Values.externalAuth.saml -}}
{{- if .enabled }}
SAML_ENABLED: "true"
SAML_ACS_URL: {{ .acsUrl | quote }}
SAML_ISSUER: {{ .issuer | quote }}
SAML_IDP_SSO_TARGET_URL: {{ .idpSsoTargetUrl | quote }}
SAML_IDP_CERT: {{ .idpCert | quote }}
{{- if .idpCertFingerprint }}
SAML_IDP_CERT_FINGERPRINT: {{ .idpCertFingerprint | quote }}
{{- end }}
{{- if .nameIdentifierFormat }}
SAML_NAME_IDENTIFIER_FORMAT: {{ .nameIdentifierFormat | quote }}
{{- end }}
{{- if .cert }}
SAML_CERT: {{ .cert | quote }}
{{- end }}
{{- if .privateKey }}
SAML_PRIVATE_KEY: {{ .privateKey | quote }}
{{- end }}
{{- if .wantAssertionSigned }}
SAML_SECURITY_WANT_ASSERTION_SIGNED: {{ .wantAssertionSigned | quote }}
{{- end }}
{{- if .wantAssertionEncrypted }}
SAML_SECURITY_WANT_ASSERTION_ENCRYPTED: {{ .wantAssertionEncrypted | quote }}
{{- end }}
{{- if .assumeEmailIsVerified }}
SAML_SECURITY_ASSUME_EMAIL_IS_VERIFIED: {{ .assumeEmailIsVerified | quote }}
{{- end }}
{{- if .uidAttribute }}
SAML_UID_ATTRIBUTE: {{ .uidAttribute | quote }}
{{- end }}
{{- if .attributesStatements.uid }}
SAML_ATTRIBUTES_STATEMENTS_UID: {{ .attributesStatements.uid | quote }}
{{- end }}
{{- if .attributesStatements.email }}
SAML_ATTRIBUTES_STATEMENTS_EMAIL: {{ .attributesStatements.email | quote }}
{{- end }}
{{- if .attributesStatements.fullName }}
SAML_ATTRIBUTES_STATEMENTS_FULL_NAME: {{ .attributesStatements.fullName | quote }}
{{- end }}
{{- if .attributesStatements.firstName }}
SAML_ATTRIBUTES_STATEMENTS_FIRST_NAME: {{ .attributesStatements.firstName | quote }}
{{- end }}
{{- if .attributesStatements.lastName }}
SAML_ATTRIBUTES_STATEMENTS_LAST_NAME: {{ .attributesStatements.lastName | quote }}
{{- end }}
{{- if .attributesStatements.verified }}
SAML_ATTRIBUTES_STATEMENTS_VERIFIED: {{ .attributesStatements.verified | quote }}
{{- end }}
{{- if .attributesStatements.verifiedEmail }}
SAML_ATTRIBUTES_STATEMENTS_VERIFIED_EMAIL: {{ .attributesStatements.verifiedEmail | quote }}
{{- end }}
{{- else }}
SAML_ENABLED: "false"
{{- end }}
{{- end }}
{{- end }}

{{/*
CAS login info.
Renders blank if not enabled.
*/}}
{{- define "mastodon.env.auth.cas" -}}
{{- with .Values.externalAuth.cas -}}
{{- if .enabled }}
CAS_ENABLED: "true"
CAS_URL: {{ .url | quote }}
CAS_HOST: {{ .host | quote }}
CAS_PORT: {{ .port | quote }}
CAS_SSL: {{ .ssl | quote }}
{{- if .validateUrl }}
CAS_VALIDATE_URL: {{ .validateUrl | quote }}
{{- end }}
{{- if .callbackUrl }}
CAS_CALLBACK_URL: {{ .callbackUrl | quote }}
{{- end }}
{{- if .logoutUrl }}
CAS_LOGOUT_URL: {{ .logoutUrl | quote }}
{{- end }}
{{- if .loginUrl }}
CAS_LOGIN_URL: {{ .loginUrl | quote }}
{{- end }}
{{- if .uidField }}
CAS_UID_FIELD: {{ .uidField | quote }}
{{- end }}
{{- if .caPath }}
CAS_CA_PATH: {{ .caPath | quote }}
{{- end }}
{{- if .disableSslVerification }}
CAS_DISABLE_SSL_VERIFICATION: {{ .disableSslVerification | quote }}
{{- end }}
{{- if .assumeEmailIsVerified }}
CAS_SECURITY_ASSUME_EMAIL_IS_VERIFIED: {{ .assumeEmailIsVerified | quote }}
{{- end }}
{{- if .keys.uid }}
CAS_UID_KEY: {{ .keys.uid | quote }}
{{- end }}
{{- if .keys.name }}
CAS_NAME_KEY: {{ .keys.name | quote }}
{{- end }}
{{- if .keys.email }}
CAS_EMAIL_KEY: {{ .keys.email | quote }}
{{- end }}
{{- if .keys.nickname }}
CAS_NICKNAME_KEY: {{ .keys.nickname | quote }}
{{- end }}
{{- if .keys.firstName }}
CAS_FIRST_NAME_KEY: {{ .keys.firstName | quote }}
{{- end }}
{{- if .keys.lastName }}
CAS_LAST_NAME_KEY: {{ .keys.lastName | quote }}
{{- end }}
{{- if .keys.location }}
CAS_LOCATION_KEY: {{ .keys.location | quote }}
{{- end }}
{{- if .keys.image }}
CAS_IMAGE_KEY: {{ .keys.image | quote }}
{{- end }}
{{- if .keys.phone }}
CAS_PHONE_KEY: {{ .keys.phone | quote }}
{{- end }}
{{- else }}
CAS_ENABLED: "false"
{{- end }}
{{- end }}
{{- end }}

{{/*
PAM login info.
*/}}
{{- define "mastodon.env.auth.pam" -}}
{{- with .Values.externalAuth.pam -}}
{{- if .enabled }}
PAM_ENABLED: "true"
{{- if .emailDomain }}
PAM_EMAIL_DOMAIN: {{ .emailDomain | quote }}
{{- end }}
{{- if .defaultService }}
PAM_DEFAULT_SERVICE: {{ .defaultService | quote }}
{{- end }}
{{- if .controlledService }}
PAM_CONTROLLED_SERVICE: {{ .controlledService | quote }}
{{- end }}
{{- else }}
PAM_ENABLED: "false"
{{- end }}
{{- end }}
{{- end }}

{{/*
LDAP login info.
*/}}
{{- define "mastodon.env.auth.ldap" -}}
{{- with .Values.externalAuth.ldap -}}
{{- if .enabled }}
LDAP_ENABLED: "true"
LDAP_HOST: {{ .host | quote }}
LDAP_PORT: {{ .port | quote }}
LDAP_METHOD: {{ .method | quote }}
{{- if .tlsNoVerify }}
LDAP_TLS_NO_VERIFY: {{ .tlsNoVerify | quote }}
{{- end }}
{{- if .base }}
LDAP_BASE: {{ .base | quote }}
{{- end }}
{{- if .bindDn }}
LDAP_BIND_DN: {{ .bindDn | quote }}
{{- end }}
{{- if .password }}
LDAP_PASSWORD: {{ .password | quote }}
{{- end }}
{{- if .uid }}
LDAP_UID: {{ .uid | quote }}
{{- end }}
{{- if .mail }}
LDAP_MAIL: {{ .mail | quote }}
{{- end }}
{{- if .searchFilter }}
LDAP_SEARCH_FILTER: {{ .searchFilter | quote }}
{{- end }}
{{- if .uidConversion.enabled }}
LDAP_UID_CONVERSION_ENABLED: {{ .uidConversion.enabled | quote }}
{{- end }}
{{- if .uidConversion.search }}
LDAP_UID_CONVERSION_SEARCH: {{ .uidConversion.search | quote }}
{{- end }}
{{- if .uidConversion.replace }}
LDAP_UID_CONVERSION_REPLACE: {{ .uidConversion.replace | quote }}
{{- end }}
{{- else }}
LDAP_ENABLED: "false"
{{- end }}
{{- end }}
{{- end }}

{{/*
OAuth Global login info.
Renders blank if not enabled.
*/}}
{{- define "mastodon.env.auth.oauthGlobal" -}}
{{- with .Values.externalAuth.oauthGlobal -}}
{{- if .omniauthOnly }}
OMNIAUTH_ONLY: "true"
{{- else }}
OMNIAUTH_ONLY: "false"
{{- end }}
{{- end }}
{{- end }}

{{/*
Additional user-defined environment variables.
*/}}
{{- define "mastodon.env.extra" -}}
{{- range $k, $v := .Values.mastodon.extraEnvVars }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- end }}
