# Migrating from the previous helm chart.

This chart is intended as a replacement of our [previous chart](https://github.com/mastodon/chart), and as such there are some older features that are no longer supported, as well as changes in how chart values are passed. This guide provides a comprehensive list of things to look for when migrating from the previous chart to this chart.

# Deprecated features

Below is a list of features from the previous chart that are no longer supported in this chart, either because they were deprecated in Mastodon itself, or because they are not the recommended way to install this application.

## Chart dependencies

The previous chart used Bitnami subcharts for PostgreSQL and Redis to make installation easier at the start. We have reconsidered this strategy however, as the administration of both PostgreSQL and Redis can be a delicate process, and in our opinion, not something that should be simplified and hidden away in chart dependencies. As such, you now need to set up your own PostgreSQL and Redis instances, either via managed services in your cloud of choice, or via other in-cluster solutions. The [README](README.md) has recommendations for such solutions.

## Kubernetes volumes for assets & system files

Using Kubernetes persistent volumes for storing asset and media data is no longer supported. This is because the storage requirements for a typical Mastodon instance can increase quickly and unpredictably depending on users and activity, and `PersistentVolumes` in Kubernetes don't offer the necessary flexibility.

Using S3-compatible storage is currently the only supported method for storing media assets.

## StatsD metrics

StatsD is no longer supported for measuring metrics in Mastodon (support was dropped in v4.3).

Instead, we recommend using either Prometheus, or OpenTelemetry.

# Changes in the values file

Below are the things that have changed in the `values.yaml` file, and what steps you need to take to make sure your old values file will work with the new chart.

## camelCase standardization + value name changes

The previous chart used an inconsistent combination of snake_case and camelCase value names. In keeping with [Helm best practices](https://helm.sh/docs/chart_best_practices/values#naming-conventions) this has been rectified to only camelCase for all values. For example, `some_value` would now be `someValue`.

This can generally be addressed by replacing all snake case values (for example via regex: `s/_(\w)/\U$1/g`), but there are some values whose names in general have changed. Therefore, a full list of changed values follows, with comments indicating which are full name changes as opposed to simple snake_case -> camelCase conversions.

```yaml
mastodon:
  local_domain:                      localDomain
  web_domain:                        webDomain
  alternate_domains:                 alternateDomains
  preparedStatements:                # Removed               # Moved to `postgresql`

  s3:
    enabled:                         # Removed
    access_key:                      accessKeyId             # Full name change
    access_secret:                   secretAccessKey         # Full name change
    alias_host:                      aliasHost
    multipart_threshold:             multipartThreshold
    override_path_style:             overridePathStyle

  secrets:
    secret_key_base:                 secretKeyBase
    vapid:                           # Removed               # The VAPID keys are now in the root of `secrets`
      private_key:                   vapidPrivateKey         # Full name change
      public_key:                    vapidPublicKey          # Full name change
    activeRecordEncryption:          # Removed               # The ARE keys are now in the root of `secrets`
      primaryKey:                    arePrimaryKey           # Full name change
      deterministicKey:              areDeterministicKey     # Full name change
      keyDerivationSalt:             areKeyDerivationSalt    # Full name change

  smtp:
    auth_method:                     authMethod
    ca_file:                         caFile
    delivery_method:                 deliveryMethod
    enable_starttls:                 enableStartTls
    from_address:                    fromAddress
    return_path:                     returnPath
    openssl_verify_mode:             opensslVerifyMode
    reply_to:                        replyTo

    bulk:
      auth_method:                   authMethod
      ca_file:                       caFile
      enable_starttls:               enableStartTls
      from_address:                  fromAddress
      openssl_verify_mode:           opensslVerifyMode

  streaming:
    base_url:                        baseUrl

postgresql:
  enabled:                           # Removed
  image:                             # Removed
  postgresqlHostname:                hostname                # Full name change
  postgresqlPort:                    port                    # Full name change
  postgresPassword:                  # Removed
  auth:                              # Removed               # All child values moved to root of `postgresql`
  readReplica:
    auth:                            # Removed               # All child values moved to root of `readReplica`

redis:
  enabled:                           # Removed
  image:                             # Removed
  replica:                           # Removed
  auth:                              # Removed               # All child values moved to root of `redis`
  sidekiq:
    auth:                            # Removed               # All child values moved to root of `sidekiq`
  cache:
    auth:                            # Removed               # All child values moved to root of `cache`

elasticsearch:
  user:                              username                # Full name change

externalAuth:
  oidc:
    display_name:                    displayName
    uid_field:                       uidField
    client_id:                       clientId
    client_secret:                   clientSecret
    redirect_uri:                    redirectUri
    assume_email_is_verified:        assumeEmailIsVerified
    client_auth_method:              clientAuthMethod
    response_type:                   responseType
    response_mode:                   responseMode
    send_nonce:                      sendNonce
    send_scope_to_token_endpoint:    sendScopeToTokenEndpoint
    idp_logout_redirect_uri:         idpLogoutRedirectUri
    http_scheme:                     httpScheme
    jwks_uri:                        jwksUri
    auth_endpoint:                   authEndpoint
    token_endpoint:                  tokenEndpoint
    user_info_endpoint:              userInfoEndpoint
    end_session_endpoint:            endSessionEndpoint
  saml:
    acs_url:                         acsUrl
    idp_sso_target_url:              idpSsoTargetUrl
    idp_cert:                        idpCert
    idp_cert_fingerprint:            idpCertFingerprint
    name_identifier_format:          nameIdentifierFormat
    private_key:                     privateKey
    want_assertion_signed:           wantAssertionSigned
    want_assertion_encrypted:        wantAssertionEncrypted
    assume_email_is_verified:        assumeEmailIsVerified
    uid_attribute:                   uidAttribute
    attributes_statements:           attributesStatements
      full_name:                     fullName
      first_name:                    firstName
      last_name:                     lastName
      verified_email:                verifiedEmail
  oauth_global:                      oauthGlobal
    omniauth_only:                   omniauthOnly
  cas:
    validate_url:                    validateUrl
    callback_url:                    callbackUrl
    logout_url:                      logoutUrl
    login_url:                       loginUrl
    uid_field:                       uidField
    ca_path:                         caPath
    disable_ssl_verification:        disableSslVerification
    assume_email_is_verified:        assumeEmailIsVerified
    keys:
      first_name:                    firstName
      last_name:                     lastName
  pam:
    email_domain:                    emailDomain
    default_service:                 defaultService
    controlled_service:              controlledService
  ldap:
    tls_no_verify:                   tlsNoVerify
    bind_dn:                         bindDn
    search_filter:                   searchFilter
    uid_conversion:                  uidConversion
```

## Changes to existingSecrets

This chart has significantly better support for using existing Secrets in kubernetes, as well as better standardization of how it works across the chart as a whole. For every value that is considered sensitive, there are always two corresponding fields: `existingSecret` and `existingSecretKeys`. The former specifies the Secret object name, the former specifies all the keys within the secret for each value, with defaults already specified in `values.yaml`.

A full list of where existing secrets can be specified, as well as the values they replace, follows:

```yaml:
mastodon:

  # Mastodon general secrets.
  secrets:
    secretKeyBase: ""
    vapidPrivateKey: ""
    vapidPublicKey: ""
    arePrimaryKey: ""
    areDeterministicKey: ""
    areKeyDerivationSalt: ""

  # S3 asset upload secrets.
  s3Upload:
    accessKeyId:
    secretAccessKey: ""

  # Extra certs for streaming.
  streaming:
    extraCerts:
      caCerts: ""

  # S3 secrets.
  s3:
    accessKeyId: ""
    secretAccessKey: ""

  # Deepl secrets.
  deepl:
    apiKey: ""

  # hCaptcha secrets.
  hcaptcha:
    apiKey: ""

  # SMTP secrets.
  smtp:
    username: ""
    password: ""

    # SMTP bulk stream secrets.
    bulk:
      username: ""
      password: ""

  # Cache buster secrets.
  cacheBuster:
    authToken: ""

# PostgreSQL secrets.
postgresql:
  username: ""
  password: ""

  # PostgreSQL read replica secrets.
  readReplica:
    username: ""
    password: ""

# Redis secrets.
redis:
  password: ""

  # Redis sidekiq secrets.
  sidekiq:
    password: ""

  # Redis cache secrets.
  cache:
    password: ""

# Elasticsearch secrets.
elasticsearch:
  username: ""
  password: ""

# LDAP secrets.
externalAuth:
  ldap:
    password: ""
