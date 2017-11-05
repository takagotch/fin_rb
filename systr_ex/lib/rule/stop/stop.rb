# coding: Windows-31J

require "./lib/base"

# �X�g�b�v�N���X
class Stop < Rule
  def get_stop(position, index)
    with_valid_indicators do
      if position.long?
        stop_price_long(position, index)
      elsif position.short?
        stop_price_short(position, index)
      end
    end
  end
end
