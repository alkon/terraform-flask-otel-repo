# Test the rendered YAML later
output "loki_rendered_yaml_output" {
  value       = local.loki_values
  description = "The YAML string rendered for Loki Helm values."
}