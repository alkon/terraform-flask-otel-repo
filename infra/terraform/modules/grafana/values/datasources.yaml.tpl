adminUser: "admin"
adminPassword: "admin" # Set admin password directly here
datasources:
  datasources.yaml: # This is the standard path for provisioning datasources in Grafana Helm chart
    apiVersion: 1
    datasources:
      - name: Prometheus
        type: prometheus
        url: "${thanos_query_url}" # Use the variable passed from main.tf
        isDefault: true
        access: proxy
        editable: true