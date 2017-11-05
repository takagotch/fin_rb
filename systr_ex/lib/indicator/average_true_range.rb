# coding: Windows-31J

require "./lib/base"

# �^�̒l���̕��σN���X
# �^�̒l��(�O���̏I�l�Ɩ{���̍��l�̍����ق�
#   �| �O���̏I�l�Ɩ{���̈��l�̈�����)�̈ړ�����
class AverageTrueRange < Indicator
  def initialize(stock, params)
    @stock = stock
    @span = params[:span]
  end

  def calculate_indicator
    true_ranges = @stock.prices.map_indicator(2) do |prices|
      previous_close = prices.first[:close]  # �O���I�l
      current_high   = prices.last[:high]    # �{�����l
      current_low    = prices.last[:low]     # �{�����l
      true_high = [previous_close, current_high].max   # �^�̍��l
      true_low  = [previous_close, current_low].min    # �^�̈��l
      true_high - true_low                   # �^�̒l��
    end
    true_ranges.moving_average(@span)  # �^�̒l���̈ړ�����
  end
end
