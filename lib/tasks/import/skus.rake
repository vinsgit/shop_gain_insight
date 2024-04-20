# frozen_string_literal: true

namespace :import do
  desc 'import skus from prepared sheet'
  task skus: :environment do
    sheet = Roo::Spreadsheet.open('lib/tasks/import/skus.xlsx', encoding: 'iso-8859-1')

    puts 'Shop Name: '

    shop_name = STDIN.gets.chomp
    shop = Shop.find_by_name(shop_name)
    if shop.blank?
      puts 'Shop not found'
      exit(-1)
    end

    (2..1441).each do |i|
      item_link = ::ItemLink.find_or_initialize_by(name: sheet.row(i)[0], shop_id: shop.id)
      sku = ::Sku.find_or_initialize_by(name: sheet.row(i)[1], shop_id: shop.id)

      sku.save

      item_link.skus << sku
      item_link.save
    end

    puts "Sku: #{Sku.count}, Item Link: #{ItemLink.count} now"
  end
end
