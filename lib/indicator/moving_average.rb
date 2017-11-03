# coding: Windows-31J

require "./lib/base"

# �ړ����σN���X
# �n�l�A���l�A���l�A�I�l
#�i:open, :high, :low, :close�j�̂����ǂ�ł�
# :price_at�p�����[�^�[���w�肵�Ȃ���΁A�I�l�Ōv�Z����
class MovingAverage < Indicator
  def initialize(stock, params)
    @stock = stock
    @span = params[:span]
    @price_at = params[:price_at] || :close
  end

  def calculate_indicator
    prices = @stock.send(@price_at.to_s + "_prices")
    prices.moving_average(@span)
  end
end
