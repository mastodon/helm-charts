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
Common deployment template spec (volumes included).
Some deployments have different volume mounting requirements.
*/}}
{{- define "mastodon.deployment.specWithVolumes" -}}
{{- include "mastodon.deployment.spec" . }}
{{- with .Values.volumes }}
volumes:
  {{- toYaml . | nindent 8 }}
{{- end }}
{{- end }}

{{/*
Common container spec.
*/}}
{{- define "mastodon.container.spec" -}}
envFrom:
  - configMapRef:
      name: {{ include "mastodon.configMapName" . }}
  - secretRef:
      name: {{ include "mastodon.secrets.secretName" . }}
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
{{- with .Values.volumeMounts }}
volumeMounts:
  {{- toYaml . | nindent 12 }}
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
  - secretRef:
      name: {{ include "mastodon.secrets.secretNamePreDeploy" . }}
  {{- if .Values.mastodon.extraEnvFrom }}
  - configMapRef:
      name: {{ .Values.mastodon.extraEnvFrom }}
  {{- end }}
{{- end }}
