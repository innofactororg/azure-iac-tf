output "id" {
  value = try(azurerm_sentinel_watchlist_item.watchlist_item[each.key].id,null)
}
