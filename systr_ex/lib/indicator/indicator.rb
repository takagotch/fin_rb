# coding: Windows-31J

require "./lib/array"

# �e�N�j�J���w�W�̐e�N���X
class Indicator
  include Enumerable

  def initialize(stock)
    @stock = stock
  end

  def each
    @indicator.each {|value| yield value}
  end

  # �v�f�� nil �̎��� :no_value �� throw ����
  def [](index)
    if index.kind_of? Numeric and
       (@indicator[index].nil? or index < 0)
      throw :no_value
    else
      @indicator[index]
    end
  end

  def calculate
    @indicator = calculate_indicator
    self
  end

  # �w�W�v�Z�̎����B�q�N���X�ŃI�[�o�[���C�h����
  def calculate_indicator; end
end

