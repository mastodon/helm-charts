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
  {{- toYaml . | nindent 8 }}
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
  {{- toYaml . | nindent 8 }}
{{- end }}
{{- end }}

{{/*
Common deployment template spec (volumes included).
Some deployments have different volume mounting requirements.
*/}}
{{- define "mastodon.deployment.specWithVolumes" -}}
{{- include "mastodon.deployment.spec" . }}
{{- if or .Values.volumeMounts .Values.elasticsearch.caSecret.name }}
volumes:
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
Common container spec (with volumes).
Some containers have different volume mounting requirements.
*/}}
{{- define "mastodon.container.specWithVolumes" -}}
{{- include "mastodon.container.spec" . }}
{{- if or .Values.volumeMounts .Values.elasticsearch.caSecret.name }}
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

{{/*
Common container spec (pre-deploy jobs).
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
