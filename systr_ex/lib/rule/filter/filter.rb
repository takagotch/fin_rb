# coding: Windows-31J

require "./lib/base"

# �t�B���^�[�N���X
# �d�|���𐧌�����
class Filter < Rule
  def get_filter(index)
    with_valid_indicators {filter(index)}
  end
end
