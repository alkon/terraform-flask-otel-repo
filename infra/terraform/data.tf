data "template_file" "create_k3d_script" {
  template = file("${path.module}/scripts/create_k3d_cluster.sh.tpl")
  vars = {
    cluster_name   = var.k3d_cluster_name
    port_mappings  = "--port \"5000:5000@loadbalancer\"" # can be passed from tfvars
    agent_count    = 1
    server_args    = ""
  }
}