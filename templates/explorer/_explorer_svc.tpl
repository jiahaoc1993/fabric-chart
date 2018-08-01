{{- define "explorer.service" }}

{{- $namespace := .namespace }}
{{- $name := .name }}

apiVersion: v1
kind: Service
metadata:
   namespace: {{ $namespace }}
   name: {{ $name }}
spec:
   selector:
       app: explorer
   ports:
      - name: explorer
        protocol: TCP
        port: 8080
        targetPort: 8080

---
{{- end }}