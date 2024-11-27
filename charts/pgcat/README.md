# PgCat Custom Helm Chart

This is a custom helm chart for deploying [PgCat](https://github.com/postgresml/pgcat)

We are using a custom chart because the official chart doesn't have provisions for specifying sensitive values (such as admin passwords) as kubernetes secrets, or the implementation of such functionality relies on helm functions (e.g. `lookup`) that isn't supported by Argo CD, our GitOps tools.
