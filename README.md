# Mastodon Helm Charts repository

This repository contains the various Helm charts maintained by Mastodon.

Those charts are automatically published at https://mastodon.github.io/helm-charts/

# Chart testing

This repo utilizes Helm's [chart-testing](https://github.com/helm/chart-testing) tool to lint and test helm charts. When creating a new chart, in order to make sure tests are run correctly, make sure that:

- All charts for this repo live in the `charts/` directory
- Any default values required for a successful deploy of a given chart are added to `<chart>/ci/default-values.yaml`

## Custom pre-install setup

Some of the charts that live in this repo require specific setup in order to successfully be tested and installed. The testing pipeline therefore checks for the presence of a `<chart>/ci/setup` file to run when performing tests on a given chart. Any custom configuration that needs to be run before installing can be done in this file.
