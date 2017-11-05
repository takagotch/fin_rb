# coding: Windows-31J

require "./lib/base"

# ��Ԃ̍��l���l�N���X
# 4�{�l���ꂼ��̍��l�E���l�ɑΉ�
class HighLow < Indicator
  def initialize(stock, params)
    @stock = stock
    @span = params[:span]
    @high_low = params[:high_low]
    @price_at = params[:price_at] || params[:high_low]
  end

  def calculate_indicator
    prices = @stock.map_prices(@price_at)
    prices.send(@high_low.to_s + "s", @span)
  end
end
