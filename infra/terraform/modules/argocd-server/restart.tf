### Because Argo CD doesn't pick up ConfigMap changes automatically — the pod must be restarted. But:
#
# 1)We don’t want to restart every time unnecessarily (bad for stability)
#
# 2) We only want to restart when the config truly changes
#
# So we calculate a hash (sha1(jsonencode(...))) and use that to conditionally trigger
# resource "null_resource" "restart_argocd_server" {
#   triggers = {
#     config_map_checksum = sha1(jsonencode(kubernetes_config_map.argocd_cm.data))
#   }
#
#   provisioner "local-exec" {
#     command = "kubectl rollout restart deployment argocd-server -n argocd"
#   }
#
#   depends_on = [kubernetes_config_map.argocd_cm]
# }