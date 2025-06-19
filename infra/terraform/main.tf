module "otel" {
  source = "./modules/otel"
}

module "flask" {
  source               = "./modules/flask"
  image                = "alkon100/flask-hello:latest"
  instrumentation_name = "flask-auto"
}
