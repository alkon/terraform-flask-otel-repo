resource "null_resource" "create_k3d_cluster" {
  provisioner "local-exec" {
    command = <<EOT
      #!/bin/bash
      set -e

      if ! k3d cluster list | grep -q "${var.k3d_cluster_name}"; then
        echo "🔧 Creating k3d cluster: ${var.k3d_cluster_name}"
        k3d cluster create ${var.k3d_cluster_name}
      else
        echo "Cluster '${var.k3d_cluster_name}' already exists. Skipping creation."
      fi
    EOT
    interpreter = ["/bin/bash", "-c"]
  }
}