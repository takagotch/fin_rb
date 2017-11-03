# coding: Windows-31J

require "./lib/base"

# MinHoldExit�N���X
# �|�W�V�����ۗL�����������ȉ��̂Ƃ��́A��d����Ȃ�
class MinHoldExit < Exit
  def initialize(params)
    @min_hold_days = params[:min_hold_days]
  end

  def check_exit(trade, index)
    return :no_exit if trade.length <= @min_hold_days
  end
end
