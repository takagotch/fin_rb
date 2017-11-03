# coding: Windows-31J

require "./lib/base"

# �u���C�N�A�E�g�d�|���N���X
# n�����l���l�̃u���C�N�Ŕ����d�|���A����d�|��
class BreakoutEntry < Entry
  include Breakout

  # ���l���u���C�N�����甃���d�|��
  # ��t���Ńu���C�N�����ꍇ�͎n�l�A
  # �U����Ńu���C�N�����ꍇ��n�����l��1�e�B�b�N��Ŕ���
  def check_long(index)
    if break_high?(index)
      enter_long(index, *price_and_time_for_break_high(index))
    end
  end

  # ���l���u���C�N�����甄��d�|��
  # ��t���Ńu���C�N�����ꍇ�͎n�l�A
  # �U����Ńu���C�N�����ꍇ��n�����l��1�e�B�b�N���Ŕ���
  def check_short(index)
    if break_low?(index)
      enter_short(index, *price_and_time_for_break_low(index))
    end
  end
end
