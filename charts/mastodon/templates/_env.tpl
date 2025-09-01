{{/*
Helper functions for building the environment ConfigMap.
*/}}

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
{{- if .hostname -}}
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
{{- if .enabled -}}
ES_ENABLED: "true"
ES_HOST: {{ required "Elasticsearch hostname is required" .hostname | quote }}
{{- if .preset }}
ES_PRESET: {{ .preset | quote }}
{{- end }}
{{- if .port }}
ES_PORT: {{ .port | quote }}
{{- end }}
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
