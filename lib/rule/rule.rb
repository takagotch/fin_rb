# coding: Windows-31J

require "./lib/trade"
require "./lib/tick"

# �e���[���̐e�N���X
class Rule
  attr_writer :stock

  def calculate_indicators; end

  private
  def with_valid_indicators
    catch(:no_value) {yield}
  end
end
