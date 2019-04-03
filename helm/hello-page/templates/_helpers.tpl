{{- define "service.name" -}}
{{- default .Chart.Name .Values.custom.serviceName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "service.releaseName" -}}
{{- default .Release.Name .Values.custom.releaseName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
