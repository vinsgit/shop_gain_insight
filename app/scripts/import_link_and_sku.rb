# input: the sheet
(2..1441).each do |i|
  item_link = row(i)[0]

  sku = row(i)[1]

  link = ::ItemLink.find_or_initialize_by(name: item_link, shop_id: @shop_id)
  sku = ::Sku.find_or_initialize_by(name: sku, shop_id: @shop_id)
  sku.save
  link.skus << sku
  link.save
end