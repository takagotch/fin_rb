# coding: Windows-31J

require "./lib/base"

# �^�̒l���̈ړ����ρiATR�j�Ɋ�Â��X�g�b�v�N���X
# �d�|�l����
# �����ł́An���Ԃ�ATR��x�{�A����
# ����ł́An���Ԃ�ATR��x�{�A���
# �X�g�b�v��u��
class AverageTrueRangeStop < Stop
  # :span  ATR�̊���
  # :ratio ATR�̉��{��
  def initialize(params)
    @span = params[:span]
    @ratio = params[:ratio] || 1
  end

  def calculate_indicators
    @average_true_range = AverageTrueRange.new(@stock, span: @span).calculate
  end

  # �d�|�l����n��ATR(�O��)��x�{���ɍs�����Ƃ���ɃX�g�b�v
  def stop_price_long(position, index)
    Tick.truncate(position.entry_price - range(index))
  end

  # �d�|�l����n��ATR(�O��)��x�{��ɍs�����Ƃ���ɃX�g�b�v
  def stop_price_short(position, index)
    Tick.ceil(position.entry_price + range(index))
  end

  private
  def range(index)
    @average_true_range[index - 1] * @ratio
  end
end
