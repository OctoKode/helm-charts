{{/*
Expand the name of the chart.
*/}}
{{- define "kyverno-artifact-operator.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "kyverno-artifact-operator.fullname" -}}
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
{{- define "kyverno-artifact-operator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "kyverno-artifact-operator.labels" -}}
helm.sh/chart: {{ include "kyverno-artifact-operator.chart" . }}
{{ include "kyverno-artifact-operator.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "kyverno-artifact-operator.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kyverno-artifact-operator.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
control-plane: controller-manager
{{- end }}

{{/*
Create the name of the service account to use for controller
*/}}
{{- define "kyverno-artifact-operator.serviceAccountName" -}}
{{- if .Values.controller.serviceAccount.create }}
{{- default (printf "%s-controller-manager" (include "kyverno-artifact-operator.fullname" .)) .Values.controller.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.controller.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use for watcher
*/}}
{{- define "kyverno-artifact-operator.watcherServiceAccountName" -}}
{{- if .Values.watcher.serviceAccount.create }}
{{- default (printf "%s-kyverno-artifact-watcher" (include "kyverno-artifact-operator.fullname" .)) .Values.watcher.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.watcher.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Namespace name
*/}}
{{- define "kyverno-artifact-operator.namespace" -}}
{{- if .Values.namespace.create }}
{{- .Values.namespace.name }}
{{- else }}
{{- .Release.Namespace }}
{{- end }}
{{- end }}
