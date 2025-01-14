resource "azurerm_cdn_frontdoor_rule" "example" {
  depends_on = [azurerm_cdn_frontdoor_origin_group.databricks_example_origin_group, azurerm_cdn_frontdoor_origin.primary_workspace_origin, azurerm_cdn_frontdoor_origin.secondary_workspace_origin]

  name                      = "DatabricksExampleRule"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.databricks_example_ruleset.id
  order                     = 1
  behavior_on_match         = "Continue"

  actions {
    url_redirect_action {
      redirect_type        = "Found"
      redirect_protocol    = "MatchRequest"
      destination_path     = "/sql/1.0/warehouses/${var.primary_warehouse_id}"
      destination_hostname = "${var.primary_workspace_url}"
    }
  }

  conditions {
    url_path_condition {
      operator         = "Contains"
      negate_condition = false
      match_values     = ["warehouse"]
    }
  }
}