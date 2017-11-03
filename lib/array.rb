# coding: Windows-31J

# Array �N���X�̊g��
# ���v�A���ρA�ړ����ρA��ԍ��l�E���l�����߂郁�\�b�h��ǉ�
# �z�񂩂�w�W�v�Z���郁�\�b�h���`
class Array
  # ���v
  def sum
    self.inject(:+)
  end

  # ����
  def average
    sum.to_f / self.size
  end

  # ���̔z��Ɠ����v�f���̔z���Ԃ�
  # �z��̊e�v�f�� span �����o�����z��ɑ΂��āA���Ԃ�
  # �u���b�N�Ŏ������ꂽ���������s����
  # �Ăяo�����Farray.map_indicator(span) {|span_array| ...}
  def map_indicator(span)
    indicator_array = Array.new(self.size)
    self.each_cons(span).with_index do |span_array, index|
      # �w�W���炳��Ɏw�W�����ꍇ�A
      # �ŏ��̂ق��� nil �͂Ƃ΂�
      next if span_array.include?(nil)
      indicator_array[index + span - 1] = yield span_array
    end
    indicator_array
  end

  # �ړ�����
  def moving_average(span)
    map_indicator(span) {|vals| vals.average}
  end

  # ��ԍ��l
  def highs(span)
    map_indicator(span) {|vals| vals.max}
  end

  # ��Ԉ��l
  def lows(span)
    map_indicator(span) {|vals| vals.min}
  end
end
