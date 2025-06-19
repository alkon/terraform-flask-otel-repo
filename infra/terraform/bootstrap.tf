resource "null_resource" "create_k3d_cluster" {
  provisioner "local-exec" {
    command = <<EOT
if ! k3d cluster list | grep -q ${var.k3d_cluster_name}; then
  k3d cluster create ${var.k3d_cluster_name} \
    --servers 1 --agents 1 --wait \
    --port "8080:80@loadbalancer"
else
  echo "k3d cluster '${var.k3d_cluster_name}' already exists"
fi
EOT
  }

  triggers = {
    always_run = timestamp()
  }
}
