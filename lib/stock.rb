# coding: Windows-31J

# ����\���N���X
class Stock
  attr_reader :code, :market, :unit, :prices

  def initialize(code, market, unit)
    @code = code
    @market = market
    @unit = unit
    @prices = []
    @price_hash = Hash.new
  end

  # 1�����̊�����������
  def add_price(date, open, high, low, close, volume)
    @prices << {:date => date,
      :open => open,
      :high => high,
      :low  => low,
      :close => close,
      :volume => volume}
  end

  # �����f�[�^�̂����A����̎��
  # �i���t�A4�{�l�̂ǂꂩ�A�o�����j�̔z��𓾂�
  def map_prices(price_name)
    @price_hash[price_name] ||= @prices.map {|price| price[price_name]}
  end

  # ���t�̔z��
  def dates
    map_prices(:date)
  end

  # �n�l�̔z��
  def open_prices
    map_prices(:open)
  end

  # ���l�̔z��
  def high_prices
    map_prices(:high)
  end

  # ���l�̔z��
  def low_prices
    map_prices(:low)
  end

  # �I�l�̔z��
  def close_prices
    map_prices(:close)
  end

  # �o�����̔z��
  def volumes
    map_prices(:volume)
  end
end
