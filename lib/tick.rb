# coding: Windows-31J

# �Ēl���W���[��
# �Ēl�P�ʂɍ��킹�Ēl�i���㉺��������ۂ߂��肷��
module Tick
  module_function
  # �Ēl�P��
  def size(price)
    if price <= 3000
      1
    elsif 3000 < price && price <= 5000
      5
    elsif 5000 < price && price <= 30000
      10
    elsif 30000 < price && price <= 50000
      50
    elsif 50000 < price && price <= 300000
      100
    elsif 300000 < price && price <= 500000
      500
    elsif 500000 < price && price <= 3000000
      1000
    elsif 3000000 < price && price <= 5000000
      5000
    elsif 5000000 < price && price <= 30000000
      10000
    elsif 30000000 < price && price <= 50000000
      50000
    elsif 50000000 < price
      100000
    end
  end

  # ���[�Ȑ�������̌Ăђl�ɐ؂�グ
  # ���[�łȂ���Ή������Ȃ�
  def ceil(price)
    tick_size = size(price)
    if price % tick_size == 0
      price
    else
      truncate(price) + tick_size
    end
  end

  # ���[�Ȑ��������̌Ăђl�ɐ؂艺��
  # ���[�łȂ���Ή������Ȃ�
  def truncate(price)
    (price - price % size(price)).truncate
  end

  # �ォ���A�ǂ��炩�߂����Ɋۂ߂�
  # ���[�łȂ���Ή������Ȃ�
  def round(price)
    tick_size = size(price)
    if price % tick_size * 2 >= tick_size
      ceil(price)
    else
      truncate(price)
    end
  end

  # ���e�B�b�N������
  def up(price, tick = 1)
    tick.times {price += size(price)}
    ceil(price)
  end

  # ���e�B�b�N������
  def down(price, tick = 1)
    price = truncate(price)
    tick.times {price -= size(price)}
    price
  end
end
