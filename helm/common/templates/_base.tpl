
{{- define "common.base" -}}
{{ template "common.service" . }}
---
{{ template "common.deployment" . }}
---
{{ template "common.config" . }}
---
{{ template "common.test.connection" . }}
{{- end -}}
