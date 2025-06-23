resource "null_resource" "create_k3d_cluster" {
  provisioner "local-exec" {
    command     = data.template_file.create_k3d_script.rendered
    interpreter = ["/bin/bash", "-c"]
  }
  triggers = {
    always_run = timestamp() # this forces the script to rerun every time
  }
}
