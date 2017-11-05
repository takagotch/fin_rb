# coding: Windows-31J

require "./lib/base"

# �ړ����Ϙ������ɂ���d�����N���X
# �O���̏I�l���An���ړ����ς���x%�ȓ��̂Ƃ���t���Ŏ�d����
class EstrangementExit < Exit
  def initialize(params)
    @span = params[:span]
    @rate = params[:rate]
  end

  def calculate_indicators
    @estrangement = Estrangement.new(@stock, span: @span).calculate
  end

  def check_long(trade, index)
    if @estrangement[index - 1] > (-1) * @rate
      exit(trade, index, @stock.open_prices[index], :open)
    end
  end

  def check_short(trade, index)
    if @estrangement[index - 1] < @rate
      exit(trade, index, @stock.open_prices[index], :open)
    end
  end
end
