locals {
  # This local determines the actual namespace name to use.
  # If var.namespace_name is provided, use it; otherwise, default to var.app_name_prefix.
  effective_namespace_name = var.namespace_name != "" ? var.namespace_name : var.app_name_prefix
}