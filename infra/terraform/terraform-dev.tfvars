## For tests with local Helm Chart in k8s/helm-charts/flask-app
use_local_chart     = true

# Cluster name
k3d_cluster_name = "tf-cluster"

# GitHub org or username
github_repo_owner = "alkon"

# Helm chart details
helm_chart_repo     = ""
helm_chart_name     = "flask-app"
helm_chart_version  = ""

# Docker image details (still need in local DEV test)
docker_image_repo   = "ghcr.io"
docker_image_tag    = "v0.1.0"

command = ["python"]
args = ["app.py", "--port=5000", "--log-level=debug"]
