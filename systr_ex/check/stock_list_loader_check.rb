# coding: Windows-31J

require "./lib/stock_list_loader"

sll = StockListLoader.new("data/tosho_list.txt")

puts sll.stock_info[0] #=> {:code=>1301,
                       #    :market_section=>"����1��",
                       #    :unit=>1000}
puts sll.codes[0]              #=> 1301
puts sll.codes.last            #=> 9997
puts sll.market_sections[0]    #=> "���؂P��"
puts sll.units[0]              #=> 1000

puts sll.market_sections.include?("����2��")   #=> true
sll.filter_by_market_section("����1��")
puts sll.market_sections.include?("����2��")   #=> false

