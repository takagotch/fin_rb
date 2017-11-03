# coding: Windows-31J

require "./lib/pan_database_to_stock"

pdts = PanDatabaseToStock.new(stock_list:
                              "data/tosho_list.txt",
                              market_section: "����1��")

stock = pdts.generate_stock(1301)
puts stock.code                   #=> 1301
puts stock.dates.first
puts stock.open_prices.first

pdts.each_stock do |stock|
  puts stock.code
end                               #=> 1301, 1332, 1334, ...

# �J�n���ƏI�������w��
pdts.from = "2011/01/04"
pdts.to   = "2011/06/30"

pdts.each_stock do |stock|
  puts [stock.code, stock.dates.first, stock.dates.last].join(" ")
end

# ���������ւ̑Ή�
# �t�@�[�X�g���e�C�����O 2002/02/25��1:2�̊�������
pdts = PanDatabaseToStock.new(stock_list: "data/tosho_list.txt",
                              market_section: "����1��",
                              adjust_ex_rights: true)
pdts.from = "2002/01/04"
pdts.to   = "2002/02/28"
stock = pdts.generate_stock(9983)
index = stock.dates.index("2002/02/22")
puts stock.open_prices[index]     #=> 2510
                                  # :adjust_ex_rights �� false �Ȃ�5020
index = stock.dates.index("2002/02/25")
puts stock.open_prices[index]     #=> 2545
