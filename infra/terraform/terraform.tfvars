# Default values for variables. Automatically loaded by Terraform.
# For CI/CD, these values are typically overridden by -var flags or secrets.

k3d_cluster_name = "tf-cluster"

helm_chart_name = "flask-app"
helm_chart_version = "v0.1.0"

# 'release.tf' constructs the full path 'oci://ghcr.io/alkon/flask-app'
helm_chart_repo = "oci://ghcr.io"
docker_image_repo = "ghcr.io"
docker_image_tag = "v0.1.0"

github_repo_owner = "alkon"