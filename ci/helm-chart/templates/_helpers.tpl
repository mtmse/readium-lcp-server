{{- define "lcp.get-certs" -}}
{{- $certs := lookup "v1" "Secret" .Release.Namespace "lcp-certs" -}}
{{- if $certs -}}
cert.pem: {{ index $certs.data "cert.pem" }}
privkey.pem: {{ index $certs.data "privkey.pem" }}
{{- else -}}
{{- $cert := genSelfSignedCert "lcp" nil nil 365 -}}
cert.pem: {{ $cert.Cert | toString | b64enc }}
privkey.pem: {{ $cert.Key | toString | b64enc }}
{{- end -}}
{{- end -}}
