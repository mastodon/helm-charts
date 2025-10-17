{{/*
Templates for generating environment variables from kubernetes secrets.
*/}}

{{/*
Mastodon secrets.
*/}}
{{- define "mastodon.secrets.secret" -}}
- name: "SECRET_KEY_BASE"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.secretName" . }}
      key: {{ .Values.mastodon.secrets.existingSecretKeys.secretKeyBase }}
- name: "VAPID_PRIVATE_KEY"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.secretName" . }}
      key: {{ .Values.mastodon.secrets.existingSecretKeys.vapidPrivateKey }}
- name: "VAPID_PUBLIC_KEY"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.secretName" . }}
      key: {{ .Values.mastodon.secrets.existingSecretKeys.vapidPublicKey }}
- name: "ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.secretName" . }}
      key: {{ .Values.mastodon.secrets.existingSecretKeys.arePrimaryKey }}
- name: "ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.secretName" . }}
      key: {{ .Values.mastodon.secrets.existingSecretKeys.areDeterministicKey }}
- name: "ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.secretName" . }}
      key: {{ .Values.mastodon.secrets.existingSecretKeys.areKeyDerivationSalt }}
{{- end }}

{{/*
Database secrets.
*/}}
{{- define "mastodon.secrets.database" -}}
- name: "DB_PASS"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.postgresName" . }}
      key: {{ .Values.postgresql.existingSecretKeys.username }}
{{- if or .Values.postgresql.readReplica.existingSecret .Values.postgresql.readReplica.password }}
- name: "REPLICA_DB_PASS"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.postgresReplicaName" . }}
      key: {{ .Values.postgresql.existingSecretKeys.password }}
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
      key: {{ .Values.redis.existingSecretKeys.password }}
{{- if .Values.redis.sidekiq.enabled }}
- name: "SIDEKIQ_REDIS_PASSWORD"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.redisSidekiqName" . }}
      key: {{ .Values.redis.sidekiq.existingSecretKeys.password }}
{{- end }}
{{- if .Values.redis.cache.enabled }}
- name: "CACHE_REDIS_PASSWORD"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.redisCacheName" . }}
      key: {{ .Values.redis.cache.existingSecretKeys.password }}
{{- end }}
{{- end }}

{{/*
Elasticsearch secrets.
*/}}
{{- define "mastodon.secrets.elasticsearch" -}}
- name: "ES_USER"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.elasticsearchName" . }}
      key: {{ .Values.elasticsearch.existingSecretKeys.username }}
- name: "ES_PASS"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.elasticsearchName" . }}
      key: {{ .Values.elasticsearch.existingSecretKeys.password }}
{{- end }}

{{/*
S3 secrets.
*/}}
{{- define "mastodon.secrets.s3" -}}
- name: "AWS_ACCESS_KEY_ID"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.s3Name" . }}
      key: {{ .Values.mastodon.s3.existingSecretKeys.accessKeyId }}
- name: "AWS_SECRET_ACCESS_KEY"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.s3Name" . }}
      key: {{ .Values.mastodon.s3.existingSecretKeys.secretAccessKey }}
{{- end }}

{{/*
SMTP secrets.
*/}}
{{- define "mastodon.secrets.smtp" -}}
- name: "SMTP_LOGIN"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.smtpName" . }}
      key: {{ .Values.mastodon.smtp.existingSecretKeys.username }}
- name: "SMTP_PASSWORD"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.smtpName" . }}
      key: {{ .Values.mastodon.smtp.existingSecretKeys.password }}
{{- if .Values.mastodon.smtp.bulk.enabled }}
- name: "BULK_SMTP_LOGIN"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.smtpBulkName" . }}
      key: {{ .Values.mastodon.smtp.bulk.existingSecretKeys.username }}
- name: "BULK_SMTP_PASSWORD"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.smtpBulkName" . }}
      key: {{ .Values.mastodon.smtp.bulk.existingSecretKeys.password }}
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
      key: {{ .Values.mastodon.deepl.existingSecretKeys.apiKey }}
{{- end }}

{{/*
hCaptcha secrets.
*/}}
{{- define "mastodon.secrets.hcaptcha" -}}
- name: "HCAPTCHA_SECRET_KEY"
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.hcaptchaName" . }}
      key: {{ .Values.mastodon.hcaptcha.existingSecretKeys.apiKey }}
{{- end }}

{{/*
Cache buster secrets.
*/}}
{{- define "mastodon.secrets.cacheBuster" -}}
- name: CACHE_BUSTER_SECRET
  valueFrom:
    secretKeyRef:
      name: {{ include "mastodon.secrets.cacheBusterName" . }}
      key: {{ .Values.mastodon.cacheBuster.existingSecretKeys.authToken }}
{{- end }}
