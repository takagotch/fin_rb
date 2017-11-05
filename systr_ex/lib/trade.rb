# coding: Windows-31J

# �����\���N���X
class Trade
  attr_accessor :stock_code, :trade_type, :entry_date,
    :entry_price, :entry_time, :volume, :exit_date,
    :exit_price, :exit_time, :length, :first_stop, :stop

  # �d�|����
  def initialize(params)
    @stock_code  = params[:stock_code]
    @trade_type  = params[:trade_type]
    @entry_date  = params[:entry_date]
    @entry_price = params[:entry_price]
    @volume      = params[:volume]
    @entry_time  = params[:entry_time]
    @length = 1
  end

  # ��d����
  def exit(params)
    @exit_date  = params[:exit_date]  || params[:date]
    @exit_price = params[:exit_price] || params[:price]
    @exit_time  = params[:exit_time]  || params[:time]
  end

  # ��d�����ς݂��ǂ���
  def closed?
    if @exit_date && @exit_price
      true
    else
      false
    end
  end

  # �����g���[�h���ǂ���
  def long?
    @trade_type == :long
  end

  # ����g���[�h���ǂ���
  def short?
    @trade_type == :short
  end

  # ���v���z
  def profit
    plain_result * @volume
  end

  # %���v
  def percentage_result
    (plain_result.to_f / @entry_price) * 100
  end

  # R
  def r
    return unless @first_stop
    if long?
      @entry_price - @first_stop
    elsif short?
      @first_stop - @entry_price
    end
  end

  # R�{��
  def r_multiple
    return unless @first_stop
    return if r == 0
    plain_result.to_f / r.to_f
  end

  private
  # �������|���Ȃ����v
  def plain_result
    if long?
      @exit_price - @entry_price
    elsif short?
      @entry_price - @exit_price
    end
  end
end
