# 1. Adds flexibility — allows namespace_name to be optional and fallback to app_name_prefix
# 2. Makes namespace management DRY (don't repeat yourself) across multiple resources
# 3. Encourages cleaner code by keeping the ternary logic in one place

locals {
  # This local determines the actual namespace name to use.
  # If var.namespace_name is provided, use it; otherwise, default to var.app_name_prefix.
  effective_namespace_name = var.namespace_name != "" ? var.namespace_name : var.app_name_prefix
}