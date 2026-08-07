{{/*
General environment definition for all pods.
*/}}
{{- define "fediscoverer.env" -}}
- name: DOMAIN
  value: {{ .Values.config.domain }}
- name: SECRET_KEY_BASE
  valueFrom:
    secretKeyRef:
      name: {{ include "fediscoverer.secrets.secretKeyBase" (merge (dict "preDeploy" .preDeploy ) .) }}
      key: {{ .Values.config.existingSecretKeys.secretKeyBase }}
- name: DATABASE_URL
  value: {{ include "fediscoverer.database.uri" . }}
- name: FEDISCOVERER_DATABASE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.config.database.password.secretKeyRef.name }}
      key: {{ .Values.config.database.password.secretKeyRef.key }}
{{- end }}
