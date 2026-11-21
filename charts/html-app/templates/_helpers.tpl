{{- define "html-app.name" -}}
{{- .Release.Name | lower | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "html-app.labels" -}}
app.kubernetes.io/name: {{ include "html-app.name" . }}
app.kubernetes.io/part-of: {{ .Values.app.department }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
gitops/env: {{ .Values.app.env }}
{{- end -}}

{{- define "html-app.selector" -}}
app.kubernetes.io/name: {{ include "html-app.name" . }}
{{- end -}}

{{/* The page: student's own html (rendered with tpl) or the default page */}}
{{- define "html-app.page" -}}
{{- if .Values.html -}}
{{ tpl .Values.html . }}
{{- else -}}
{{- $title := .Values.page.title | default (printf "%s | %s | %s" .Values.app.name .Values.app.department .Values.app.env) -}}
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{{ $title }}</title>
  <style>
    body { margin: 0; min-height: 100vh; display: grid; place-items: center;
           font-family: system-ui, sans-serif; background: {{ .Values.page.color }}; color: #fff; }
    main { text-align: center; padding: 2rem; background: rgba(0,0,0,.25); border-radius: 12px; }
    h1 { margin: 0 0 .5rem; }
    code { opacity: .8; }
  </style>
</head>
<body>
  <main>
    <h1>{{ $title }}</h1>
    <p>{{ .Values.page.message }}</p>
    <code>department={{ .Values.app.department }} env={{ .Values.app.env }} replicas={{ .Values.replicaCount }}</code>
  </main>
</body>
</html>
{{- end -}}
{{- end -}}
