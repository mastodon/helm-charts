{{/*
Expand the name of the chart.
*/}}
{{- define "mastodon.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mastodon.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "mastodon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "mastodon.labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "mastodon.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
User-defined labels.
*/}}
{{- define "mastodon.userLabels" -}}
{{- range $k, $v := .Values.mastodon.labels }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- end }}

{{/*
User-defined pod labels.
*/}}
{{- define "mastodon.podUserLabels" -}}
{{- range $k, $v := .Values.podLabels }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "mastodon.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mastodon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Rolling pod annotations.
Ensures that pods will all get rotated if the helm chart is modified in any way.
*/}}
{{- define "mastodon.rollingPodAnnotations" -}}
{{- if .Values.revisionPodAnnotation }}
rollme: {{ .Release.Revision | quote }}
{{- end }}
checksum/config-configmap: {{ include ( print $.Template.BasePath "/configmap-env.yaml" ) . | sha256sum | quote }}
{{- end }}

{{/*
User-defined deployment annotations.
*/}}
{{- define "mastodon.userDeployAnnotations" -}}
{{- range $k, $v := .Values.deploymentAnnotations }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- end }}

{{/*
User-defined pod annotations.
*/}}
{{- define "mastodon.userPodAnnotations" -}}
{{- range $k, $v := .Values.podAnnotations }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- end }}

{{/*
User-defined job annotations.
*/}}
{{- define "mastodon.userJobAnnotations" -}}
{{- range $k, $v := .Values.jobAnnotations }}
{{ $k }}: {{ quote $v }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "mastodon.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mastodon.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Main ConfigMap name.
*/}}
{{- define "mastodon.configMapName" -}}
{{- printf "%s-env" (include "mastodon.fullname" .) }}
{{- end }}

{{/*
Secret name containing mastodon secrets.
*/}}
{{- define "mastodon.secrets.secretName" -}}
{{- if .Values.mastodon.secrets.existingSecret }}
{{- .Values.mastodon.secrets.existingSecret }}
{{- else }}
{{- printf "%s-secrets" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Secret name containing mastodon secrets. (pre-deploy).
*/}}
{{- define "mastodon.secrets.secretNamePreDeploy" -}}
{{- if .Values.mastodon.secrets.existingSecret }}
{{- .Values.mastodon.secrets.existingSecret }}
{{- else }}
{{- printf "%s-secrets-predeploy" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Postgres secret name.
*/}}
{{- define "mastodon.secrets.postgresName" -}}
{{- if .Values.postgresql.existingSecret }}
{{- .Values.postgresql.existingSecret }}
{{- else }}
{{- printf "%s-postgres-auth" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Postgres replica secret name.
*/}}
{{- define "mastodon.secrets.postgresReplicaName" -}}
{{- if .Values.postgresql.readReplica.existingSecret }}
{{- .Values.postgresql.readReplica.existingSecret }}
{{- else }}
{{- printf "%s-postgres-replica-auth" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Redis secret name.
*/}}
{{- define "mastodon.secrets.redisName" -}}
{{- if .Values.redis.existingSecret }}
{{- .Values.redis.existingSecret }}
{{- else }}
{{- printf "%s-redis-auth" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Redis sidekiq secret name.
*/}}
{{- define "mastodon.secrets.redisSidekiqName" -}}
{{- if .Values.redis.sidekiq.existingSecret }}
{{- .Values.redis.sidekiq.existingSecret }}
{{- else }}
{{- printf "%s-redis-sidekiq-auth" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Redis cache secret name.
*/}}
{{- define "mastodon.secrets.redisCacheName" -}}
{{- if .Values.redis.cache.existingSecret }}
{{- .Values.redis.cache.existingSecret }}
{{- else }}
{{- printf "%s-redis-cache-auth" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Elasticsearch secret name.
*/}}
{{- define "mastodon.secrets.elasticsearchName" -}}
{{- if .Values.elasticsearch.existingSecret }}
{{- .Values.elasticsearch.existingSecret }}
{{- else }}
{{- printf "%s-elasticsearch-auth" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}

{{/*
S3 secret name.
*/}}
{{- define "mastodon.secrets.s3Name" -}}
{{- if .Values.mastodon.s3.existingSecret }}
{{- .Values.mastodon.s3.existingSecret }}
{{- else }}
{{- printf "%s-s3-auth" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}

{{/*
S3 (asset copy) secret name.
*/}}
{{- define "mastodon.secrets.s3UploadName" -}}
{{- if .Values.mastodon.hooks.s3Upload.existingSecret }}
{{- .Values.mastodon.hooks.s3Upload.existingSecret }}
{{- else }}
{{- printf "%s-s3-assets-copy-auth" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}

{{/*
SMTP secret name.
*/}}
{{- define "mastodon.secrets.smtpName" -}}
{{- if .Values.mastodon.smtp.existingSecret }}
{{- .Values.mastodon.smtp.existingSecret }}
{{- else }}
{{- printf "%s-smtp-auth" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}

{{/*
SMTP bulk secret name.
*/}}
{{- define "mastodon.secrets.smtpBulkName" -}}
{{- if .Values.mastodon.smtp.bulk.existingSecret }}
{{- .Values.mastodon.smtp.bulk.existingSecret }}
{{- else }}
{{- printf "%s-smtp-bulk-auth" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Deepl secret name.
*/}}
{{- define "mastodon.secrets.deeplName" -}}
{{- if .Values.mastodon.deepl.existingSecret }}
{{- .Values.mastodon.deepl.existingSecret }}
{{- else }}
{{- printf "%s-deepl-auth" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}

{{/*
hCaptcha secret name.
*/}}
{{- define "mastodon.secrets.hcaptchaName" -}}
{{- if .Values.mastodon.hcaptcha.existingSecret }}
{{- .Values.mastodon.hcaptcha.existingSecret }}
{{- else }}
{{- printf "%s-hcaptcha-auth" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Cache buster secret name.
*/}}
{{- define "mastodon.secrets.cacheBusterName" -}}
{{- if .Values.mastodon.cacheBuster.existingSecret }}
{{- .Values.mastodon.cacheBuster.existingSecret }}
{{- else }}
{{- printf "%s-cachebuster-auth" (include "mastodon.fullname" .) }}
{{- end }}
{{- end }}
