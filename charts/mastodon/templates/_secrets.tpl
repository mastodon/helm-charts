{{/*
Templates for generating secrets for insersion into pods.
*/}}

{{/*
Database secrets.
*/}}
{{- define "mastodon.secrets.database" -}}
- name: "DB_PASS"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.postgresName" . }}
      key: password
{{- if or .Values.postgresql.readReplica.existingSecret .Values.postgresql.readReplica.password }}
- name: "REPLICA_DB_PASS"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.postgresReplicaName" . }}
      key: password
{{- end }}
{{- end }}

{{/*
Redis secrets.
*/}}
{{- define "mastodon.secrets.redis" -}}
- name: "REDIS_PASSWORD"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.redisName" . }}
      key: password
{{- if .Values.redis.sidekiq.enabled }}
- name: "SIDEKIQ_REDIS_PASSWORD"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.redisSidekiqName" . }}
      key: password
{{- end }}
{{- if .Values.redis.cache.enabled }}
- name: "CACHE_REDIS_PASSWORD"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.redisCacheName" . }}
      key: password
{{- end }}
{{- end }}

{{/*
Elasticsearch secrets.
*/}}
{{- define "mastodon.secrets.elasticsearch" -}}
- name: "ES_PASS"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.elasticsearchName" . }}
      key: password
{{- end }}

{{/*
S3 secrets.
*/}}
{{- define "mastodon.secrets.s3" -}}
- name: "AWS_SECRET_ACCESS_KEY"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.s3Name" . }}
      key: AWS_SECRET_ACCESS_KEY
- name: "AWS_ACCESS_KEY_ID"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.s3Name" . }}
      key: AWS_ACCESS_KEY_ID
{{- end }}

{{/*
SMTP secrets.
*/}}
{{- define "mastodon.secrets.smtp" -}}
- name: "SMTP_LOGIN"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.smtpName" . }}
      key: username
- name: "SMTP_PASSWORD"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.smtpName" . }}
      key: password
{{- if .Values.mastodon.smtp.bulk.enabled }}
- name: "BULK_SMTP_LOGIN"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.smtpBulkName" . }}
      key: username
- name: "BULK_SMTP_PASSWORD"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.smtpBulkName" . }}
      key: password
{{- end }}
{{- end }}

{{/*
Deepl secrets.
*/}}
{{- define "mastodon.secrets.deepl" -}}
- name: "DEEPL_API_KEY"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.deeplName" . }}
      key: DEEPL_API_KEY
{{- end }}

{{/*
hCaptcha secrets.
*/}}
{{- define "mastodon.secrets.hcaptcha" -}}
- name: "HCAPTCHA_SECRET_KEY"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.hcaptchaName" . }}
      key: HCAPTCHA_SECRET_KEY
{{- end }}

{{/*
Cache buster secrets.
*/}}
{{- define "mastodon.secrets.cacheBuster" -}}
- name: CACHE_BUSTER_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.cacheBusterName" . }}
      key: auth-token
{{- end }}
