{{/*
Deployment templates that are common across all deployments.
*/}}

{{/*
Common deployment template spec.
*/}}
{{- define "mastodon.deployment.spec" -}}
serviceAccountName: {{ include "mastodon.serviceAccountName" . }}
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.hostAliases }}
hostAliases:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Common deployment template spec (pre-deploy).
Points to pre-deploy config maps and secrets.
*/}}
{{- define "mastodon.deployment.specPreDeploy" -}}
serviceAccountName: {{ include "mastodon.serviceAccountName" . }}-predeploy
{{- with .Values.imagePullSecrets }}
imagePullSecrets:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- with .Values.hostAliases }}
hostAliases:
  {{- toYaml . | nindent 2 }}
{{- end }}
{{- end }}

{{/*
Common container spec.
*/}}
{{- define "mastodon.container.spec" -}}
envFrom:
  - configMapRef:
      name: {{ include "mastodon.configMapName" . }}
  {{- if .Values.mastodon.extraEnvFrom }}
  - configMapRef:
      name: {{ .Values.mastodon.extraEnvFrom }}
  {{- end }}
{{- end }}

{{/*
Common container spec (pre-deploy).
Points to pre-deploy config maps and secrets.
*/}}
{{- define "mastodon.container.specPreDeploy" -}}
envFrom:
  - configMapRef:
      name: {{ include "mastodon.configMapName" . }}-predeploy
  {{- if .Values.mastodon.extraEnvFrom }}
  - configMapRef:
      name: {{ .Values.mastodon.extraEnvFrom }}
  {{- end }}
{{- end }}

{{/*
Standard volumes that will be mounted for most pods.
*/}}
{{- define "mastodon.volumes" -}}
{{- if .Values.volumeMounts }}
{{- with .Values.volumes }}
  {{- toYaml . | nindent 8 }}
{{- end }}
{{- if .Values.elasticsearch.caSecret.name }}
  - name: elasticsearch-ca
    secret:
      secretName: {{ .Values.elasticsearch.caSecret.name }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Standard volumeMounts that will be configured for most containers.
*/}}
{{- define "mastodon.volumeMounts" -}}
{{- if .Values.volumeMounts }}
volumeMounts:
{{- with .Values.volumeMounts }}
  {{- toYaml . | nindent 12 }}
{{- end }}
{{- if .Values.elasticsearch.caSecret.name }}
  - name: elasticsearch-ca
    mountPath: {{ .Values.elasticsearch.caSecret.mountPath }}
    subPath: {{ .Values.elasticsearch.caSecret.key }}
    readOnly: true
{{- end }}
{{- end }}
{{- end }}
