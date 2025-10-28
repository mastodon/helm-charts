# Introduction

This is the official [Helm](https://helm.sh/) chart for installing [Mastodon](https://github.com/mastodon/mastodon) on [Kubernetes](https://kubernetes.io/).

For the sake of simplicity and flexibility, this chart does not contain additional dependencies that are needed for Mastodon to function (such as PostgreSQL or Redis), and these must be set up & configured separately.

This chart is compatible with Mastodon versions from v4.4 and above, and has been tested with Kubernetes 1.33+ and helm 3.11+.

# ℹ️ Upgrading from pervious chart

This chart is a successor to the former official [Mastodon helm chart](https://github.com/mastodon/chart). The former chart had several inconsistencies in its design and implementation, and did not follow Helm best practices. This chart was created as a re-write to address these concerns, remove old features before Mastodon v4.4, and generally refactor/redesign the codebase to be more flexible and easy to work with.

(Details about migrating to follow)

# 📋 Prerequisites

This chart does not come with dependencies for the sake of simplicity and flexibility, so there are some things that need to be installed or set up before this chart can be installed. Many of the below dependencies are sometimes offered as managed services with some cloud providers, but we will give some recommendations for in-cluster solutions that also have their own helm charts.

## PostgreSQL

Mastodon requires a PostgreSQL database as its primary datastore for configuration, posts, etc.

Some possible solutions:
- [CloudNativePG](https://cloudnative-pg.io/) (Recommended): PostgreSQL operator that handles many aspects of HA clusters and backups automatically with minimal work on the user side. This is also the solution we use internally.
- [Crunchy Data](https://www.crunchydata.com/): Another PostgreSQL operator that is able to handle many aspects of Postgres management automatically.

## Redis

Mastodon utilizes Redis for storing feeds, Sidekiq queues and volatile caching.

There are unfortunately not many good solutions for in-cluster Redis, but there are some decent options:
- [DandyDeveloper redis-ha](https://github.com/DandyDeveloper/charts/tree/master/charts/redis-ha) (Recommended): Full-featured helm chart with support for Redis Sentinel.
- [DragonflyDB](https://github.com/dragonflydb/dragonfly-operator): Redis-compatible key/value store with less overhead and therefore less memory usage. Kubernetes operator is technically not an officially-maintained component, and has been known to have some issues regarding HA replication.
- [Valkey](https://github.com/valkey-io/valkey-helm): Fork of and proposed successor to Redis, though still v0.x and very bare-bones feature set.
- [Redis Enterprise](https://redis.io/docs/latest/operate/kubernetes/deployment/helm/): Requires Redis Enterprise, but is the only official helm chart for Redis.

## Elasticsearch (optional)

Mastodon can make use of Elasticsearch for better search functionality.

Some possible solutions:
- [Elasticsearch ECK](https://www.elastic.co/docs/deploy-manage/deploy/cloud-on-k8s) (Recommended): Official Kubernetes operator that is capable of handling the entire Elastic stack if necessary.

# 🚀 Installation

To install the helm chart, there are certain values that need to be filled in via the values file. Below is a minimal setup:

```yaml {data-filename="values.yaml"}
mastodon:

  # The name/URL of your mastodon instance
  localDomain: mydomain.social

  # Mastodon secrets
  # To generate these, see:
  # https://docs.joinmastodon.org/admin/config/#secrets
  # https://docs.joinmastodon.org/admin/config/#db-encryption-support
  secrets:
    secretKeyBase: XXXXXXXXXXXXXXXX
    vapidPrivateKey: XXXXXXXXXXXXXXXX
    vapidPublicKey: XXXXXXXXXXXXXXXX
    arePrimaryKey: XXXXXXXXXXXXXXXX
    areDeterministicKey: XXXXXXXXXXXXXXXX
    areKeyDerivationSalt: XXXXXXXXXXXXXXXX

  # S3 storage for media
  # Make sure to use your own S3 connection information
  s3:
    hostname: https://s3.us-east-1.amazonaws.com/
    endpoint: s3.us-east-1.amazonaws.com
    region: us-east-1
    bucket: mastodon-media

    accessKeyId: XXXXXXXXXXXXXXXX
    secretAccessKey: XXXXXXXXXXXXXXXX

# Ingress information (needs to match your localDomain)
ingress:
  hosts:
    - host: mydomain.social
      paths:
        - path: "/"
          pathType: Prefix
  tls:
    - secretName: mastodon-tls
      hosts:
        - mydomain.social

# External database connection info
# Make sure to use your own connection information
postgresql:
  hostname: postgres.endpoint
  username: mastodon
  password: XXXXXXXXXXXXXXXX
redis:
  hostname: redis.endpoint
  password: XXXXXXXXXXXXXXXX
```

## Using existing secrets

It's not recommended to pass sensitive information like passwords or API keys via a `values.yaml` file that gets committed to source control for security reasons. One approach that is more secure is creating the secrets in advance:

```yaml {data-filename="kubernetes-secrets.yaml"}
# Mastodon secrets
apiVersion: v1
kind: Secret
metadata:
  name: mastodon-secrets
type: Opaque
stringData:
  secret-key-base: XXXXXXXXXXXXXXXX
  vapid-private-key: XXXXXXXXXXXXXXXX
  vapid-public-key: XXXXXXXXXXXXXXXX
  are-primary-key: XXXXXXXXXXXXXXXX
  are-deterministic-key: XXXXXXXXXXXXXXXX
  are-derivation-salt: XXXXXXXXXXXXXXXX
---
# S3 authentication
apiVersion: v1
kind: Secret
metadata:
  name: mastodon-s3
type: Opaque
stringData:
  access-key-id: XXXXXXXXXXXXXXXX
  secret-access-key: XXXXXXXXXXXXXXXX
---
# PostgreSQL authentication
apiVersion: v1
kind: Secret
metadata:
  name: postgres-auth
type: kubernetes.io/basic-auth
stringData:
  username: mastodon
  password: XXXXXXXXXXXXXXXX
---
# Redis authentication
apiVersion: v1
kind: Secret
metadata:
  name: redis-auth
type: kubernetes.io/basic-auth
stringData:
  password: XXXXXXXXXXXXXXXX
```

Once these are created, we can use the existing secret names in `values.yaml` instead:

```yaml {data-filename="values.yaml"}
mastodon:
  secrets:
    existingSecret: mastodon-secrets

  s3:
    existingSecret: mastodon-s3

postgresql:
  existingSecret: postgres-auth

redis:
  existingSecret: redis-auth
```
