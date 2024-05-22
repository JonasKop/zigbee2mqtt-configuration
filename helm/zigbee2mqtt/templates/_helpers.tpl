{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "zigbee2mqtt.fullname" -}}
{{ $baseName := "" }}
{{- if contains .Chart.Name .Release.Name }}
{{- $baseName = .Release.Name }}
{{- else }}
{{- $baseName = printf "%s-%s" .Release.Name .Chart.Name }}
{{- end }}
{{- $trimmedName := $baseName | trunc 63 | trimAll "-"  }}
{{- if .Values.namePrefix }}
{{- printf "%s-%s" .Values.namePrefix $trimmedName -}}
{{- else }}
{{- $trimmedName }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "zigbee2mqtt.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "zigbee2mqtt.labels" -}}
helm.sh/chart: {{ include "zigbee2mqtt.chart" . }}
{{ include "zigbee2mqtt.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "zigbee2mqtt.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Container image
*/}}
{{- define "zigbee2mqtt.image" -}}
{{- $registryName := .Values.image.registry | default .Values.global.containerRegistry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | default .Chart.AppVersion -}}
{{- printf "%s%s%s%s%s"  $registryName "/" $repositoryName ":" $tag -}}
{{- end }}
