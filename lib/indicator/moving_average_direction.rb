# coding: Windows-31J

require "./lib/base"

# �ړ����ς̕����N���X
# �O���̈ړ����ςƖ{���̈ړ����ς���
# �{���̂ق����������:up
# �O���̂ق����������:down
# �����Ȃ��:flat
class MovingAverageDirection < Indicator
  def initialize(stock, params)
    @stock = stock
    @span = params[:span]
  end

  # �ŐV�̏I�l��@span���O�̏I�l���ׁA
  # �ŐV�̂ق���������Ώ㏸
  # �ŐV�̂ق����Ⴏ��Ή��~
  def calculate_indicator
    @stock.close_prices.map_indicator(@span + 1) do |prices|
      if prices.first < prices.last
        :up
      elsif prices.first > prices.last
        :down
      else
        :flat
      end
    end
  end
end
