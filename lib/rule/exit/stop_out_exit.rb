# coding: Windows-31J

require "./lib/base"

# �X�g�b�v�A�E�g�N���X
# ���i���X�g�b�v�Ɋ|���������d����
# �X�g�b�v�Ɋ|�������u�ԁA�����Ɏ�d����
# ��t���Ŋ|���������t���ŁA
# �ꒆ�Ɋ|��������ꒆ�Ɏ�d����
class StopOutExit < Exit
  def check_long(trade, index)
    stop = trade.stop
    price = @stock.prices[index]
    return unless stop >= price[:low]
    price, time = if stop >= price[:open]
                    [price[:open], :open]
                  else
                    [stop, :in_session]
                  end
    exit(trade, index, price, time)
  end

  def check_short(trade, index)
    stop = trade.stop
    price = @stock.prices[index]
    return unless stop <= price[:high]
    price, time = if stop <= price[:open]
                    [price[:open], :open]
                  else
                    [stop, :in_session]
                  end
    exit(trade, index, price, time)
  end
end
