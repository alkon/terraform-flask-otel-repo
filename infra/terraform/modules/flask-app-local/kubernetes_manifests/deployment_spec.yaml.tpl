replicas: ${replicas}
selector:
  match_labels:
    app: ${app_label}
template:
  metadata:
    labels:
      app: ${app_label}
    annotations:
      instrumentation.opentelemetry.io/inject-python: "true"
  spec:
    containers:
      - name: flask-app
        image: "${image_name}:${image_tag}"
        ports:
          - containerPort: ${container_port}
        env:
%{ for name, value in environment_variables ~}
          - name: ${name}
            value: ${value}
%{ endfor ~}
