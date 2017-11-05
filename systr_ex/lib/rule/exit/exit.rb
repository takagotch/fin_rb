# coding: Windows-31J

require "./lib/rule/rule"

# ��d�������[���̐e�N���X
class Exit < Rule
  def check_exit(trade, index)
    with_valid_indicators do
      if trade.long?
        check_long(trade, index)
      elsif trade.short?
        check_short(trade, index)
      end
    end
  end

  private
  def exit(trade, index, price, time)
    trade.exit(exit_date: @stock.dates[index],
               exit_price: price,
               exit_time: time)
  end
end
