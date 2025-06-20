module "otel" {
  source = "./modules/otel"

  depends_on = [
    null_resource.create_k3d_cluster
  ]
}

module "flask_app_infra" {
  source           = "./modules/flask"    # Infrastructure-focused module (!not app configs)
  app_name_prefix = "flask-app"
  namespace_name   = "flask-app-namespace" # Dedicated namespace for the Flask app

  depends_on = [
    null_resource.create_k3d_cluster
  ]
}