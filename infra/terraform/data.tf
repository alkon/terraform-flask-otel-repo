data "template_file" "create_k3d_script" {
  template = file("${path.module}/scripts/create_k3d_cluster.sh.tpl")
  vars = {
    cluster_name = var.k3d_cluster_name
    context_name = var.k3d_context_name
    host_port         = "5000"
    container_port    = "5000"
    node_filter       = "loadbalancer"
    protocol          = "tcp"
    agent_count = 1
    server_args = ""
  }
}