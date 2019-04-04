{{- define "common.notes" -}}
Your release is named {{ .Release.Name }}.
{{- end -}}

{{- define "common.service" -}}
kind: Service
apiVersion: v1
metadata:
  name: {{ include "common.releaseName" . }}
  labels:
    app.kubernetes.io/name: {{ include "common.name" . }}
    helm.sh/chart: {{ include "common.chart" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
spec:
  selector:
    app.kubernetes.io/name: {{ include "common.name" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
  ports:
  - name: http
    protocol: TCP
    port: {{ .Values.service.port }}
    targetPort: {{ .Values.image.port }}
{{- end -}}

{{- define "common.deployment" -}}
kind: Deployment
apiVersion: apps/v1
metadata:
  name: {{ include "common.releaseName" . }}
  labels:
    app.kubernetes.io/name: {{ include "common.name" . }}
    helm.sh/chart: {{ include "common.chart" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
spec:
  replicas: {{ .Values.service.replicas }}
  selector:
    matchLabels:
      app.kubernetes.io/name: {{ include "common.name" . }}
      app.kubernetes.io/instance: {{ .Release.Name }}
  template:
    metadata:
      labels:
        app.kubernetes.io/name: {{ include "common.name" . }}
        app.kubernetes.io/instance: {{ .Release.Name }}
    spec:
      containers:
      - name: {{ .Chart.Name }}
        image: '{{ .Values.image.repository }}:{{ .Values.image.tag }}'
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        envFrom:
        - configMapRef:
            name: '{{ include "common.configName" . }}'
        ports:
        - containerPort: {{ .Values.image.port }}
{{- end -}}

{{- define "common.config" -}}
kind: ConfigMap
apiVersion: v1
metadata:
  name: '{{ include "common.configName" . }}'
data:
  {{- range $key,$value := .Values.config }}
  {{ $key | snakecase | upper }}: {{ $value | squote -}}
  {{ end -}}
{{- end -}}
