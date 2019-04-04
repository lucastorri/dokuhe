{{- define "common.test.connection" -}}
apiVersion: v1
kind: Pod
metadata:
  name: "{{ include "common.releaseName" . }}-test-connection"
  labels:
    app.kubernetes.io/name: {{ include "common.name" . }}
    helm.sh/chart: {{ include "common.chart" . }}
    app.kubernetes.io/instance: {{ .Release.Name }}
    app.kubernetes.io/managed-by: {{ .Release.Service }}
  annotations:
    "helm.sh/hook": test-success
spec:
  containers:
    - name: wget
      image: busybox
      command: ['wget']
      args:  ['{{ include "common.releaseName" . }}:{{ .Values.service.port }}']
  restartPolicy: Never
{{- end -}}
