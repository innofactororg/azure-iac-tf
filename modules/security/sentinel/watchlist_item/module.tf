resource "azurerm_sentinel_watchlist_item" "watchlist_item" {

  for_each   = { for idx, value_watchlist in var.properties: idx => idx}

  # name         = var.name
  watchlist_id = var.watchlist_id
  properties   = var.properties[each.key]
}
