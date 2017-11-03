# coding: Windows-31J

require "./lib/base"

# �u���C�N�A�E�g��d�����N���X
# n�����l���l�̃u���C�N�Ŏ�d���������A��d��������
class BreakoutExit < Exit
  include Breakout

  # ���l���u���C�N�������d��������
  # ��t���Ńu���C�N�����ꍇ�͎n�l�A
  # �U����Ńu���C�N�����ꍇ��n�����l��1�e�B�b�N���Ŕ���
  def check_long(trade, index)
    if break_low?(index)
      exit(trade, index, *price_and_time_for_break_low(index))
    end
  end

  # ���l���u���C�N�����甃�߂�
  # ��t���Ńu���C�N�����ꍇ�͎n�l�A
  # �U����Ńu���C�N�����ꍇ��n�����l��1�e�B�b�N��Ŕ����߂�
  def check_short(trade, index)
    if break_high?(index)
      exit(trade, index, *price_and_time_for_break_high(index))
    end
  end
end
