# coding: Windows-31J

require "./lib/stock_data_getter"

# ���ؖ������_�E�����[�h����
# ���ؖ������_�E�����[�h��������΁Amarket = :n �Ƃ���
# ���؂Ȃ� market = :f�A�D�؂Ȃ� market = :s

from = "2011/01/4"
to   = "2011/06/30"
market = :t
sdg = StockDataGetter.new(from, to, market)

(1300..9999).each do |code|
  sdg.get_price_data(code)
end
