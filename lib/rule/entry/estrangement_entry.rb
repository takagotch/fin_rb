# coding: Windows-31J

require "./lib/base"

# �ړ����Ϙ������ɂ��d�|���N���X
# �O���̏I�l���An���ړ����ς���x%���ꂽ���t���Ŏd�|����
class EstrangementEntry < Entry
  def initialize(params)
    @span = params[:span]
    @rate = params[:rate]
  end

  def calculate_indicators
    @estrangement = Estrangement.new(@stock, span: @span).calculate
  end

  def check_long(index)
    if @estrangement[index - 1]  < (-1) * @rate
      enter_long(index, @stock.open_prices[index], :open)
    end
  end

  def check_short(index)
    if @estrangement[index - 1] > @rate
      enter_short(index, @stock.open_prices[index], :open)
    end
  end
end
