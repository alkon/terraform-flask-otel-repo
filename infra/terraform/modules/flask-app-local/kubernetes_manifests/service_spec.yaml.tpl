selector:
  app: ${app_label}
ports:
  - protocol: TCP
    port: ${service_port}
    targetPort: ${container_port}
type: ${service_type}
