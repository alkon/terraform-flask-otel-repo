# Cluster name
k3d_cluster_name = "tf-cluster"

# GitHub org or username
github_repo_owner = "alkon" # Corrected: using github_repo_owner

# The name of the Git repository
git_repo_name = "terraform-flask-otel-repo"

# Helm chart details
helm_chart_repo     = "oci://ghcr.io"
helm_chart_name     = "flask-app"
helm_chart_version  = "0.3.0"

# Docker image details
docker_image_repo   = "ghcr.io"
docker_image_tag    = "1.2.0" # Corrected: using docker_image_tag

# OpenTelemetry service name
flask_app_service_name = "flask-app-srv"

# Used by Argo Cd App mode
argocd_auth_token = ""
argocd_server = "localhost:30080" # HTTP
