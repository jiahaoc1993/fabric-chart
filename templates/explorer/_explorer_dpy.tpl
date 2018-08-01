{{- define "explorer.deployment" }}

{{- $namespace := .namespace }}
{{- $name := .name }}
{{- $pvc := .pvc }}

apiVersion: extensions/v1beta1
kind: Deployment
metadata:
   namespace: {{ $namespace }}
   name: {{ $name }}
spec:
  replicas: 1
  strategy: {}
  template:
    metadata:
      labels:
       app: explorer
    spec:
      containers:
        - name: mysql
          image: mysql:5.7
          ports:
            - containerPort: 3306
          env:
          - name: MYSQL_ROOT_PASSWORD
            value: root
          - name: MYSQL_DATABASE
            value: fabricexplorer
          volumeMounts:
           - mountPath: /docker-entrypoint-initdb.d/fabricexplorer.sql
             name: explorer
             subPath: explorer-artifacts/fabricexplorer.sql

        - name: fabric-explorer
          imagePullPolicy: IfNotPresent
          image: vmware/fabric-explorer:1.0
          command: [ "/bin/bash", "-c", "--" ]
          args: ["sleep 10;node main.js 2>&1"]
          ports:
            - containerPort: 8080
          volumeMounts:
           - mountPath: /blockchain-explorer/config.json
             name: explorer
             subPath: explorer-artifacts/config.json
           - mountPath: /blockchain-explorer/first-network/crypto-config
             name: explorer
             subPath: crypto-config
      volumes:
        - name: explorer
          persistentVolumeClaim:
              claimName: {{ $pvc }}
---

{{- end }}