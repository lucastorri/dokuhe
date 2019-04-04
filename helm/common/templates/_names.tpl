{{- define "common.name" -}}
{{- default .Chart.Name .Values.custom.serviceName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "common.releaseName" -}}
{{- default .Release.Name .Values.custom.releaseName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "common.configName" -}}
{{- include "common.releaseName" . | trunc 53 -}}-config-{{- .Release.Time.Nanos -}}
{{- end -}}
