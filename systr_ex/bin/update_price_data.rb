 # coding: Windows-31J

require "./lib/stock_data_getter"

# ���ؖ������_�E�����[�h����B
# ���ؖ������_�E�����[�h��������΁Amarket = :n �Ƃ���
# ���؂Ȃ� market = :f�A�D�؂Ȃ� market = :s

from = "1983/01/4"
to   = Date.today.to_s
market = :t
ydg = StockDataGetter.new(from, to, market)

(1300..9999).each do |code|
  ydg.update_price_data(code)
end
