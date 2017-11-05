# coding: Windows-31J

# �g���[�f�B���O�V�X�e���̊e���[���̊Ǘ�������N���X
class TradingSystem
  def initialize(rules = {})
    @entries = [rules[:entries]].flatten.compact
    @exits   = [rules[:exits]].flatten.compact
    @stops   = [rules[:stops]].flatten.compact
    @filters = [rules[:filters]].flatten.compact
  end

  def set_stock(stock)
    each_rules {|rule| rule.stock = stock}
  end

  def calculate_indicators
    each_rules {|rule| rule.calculate_indicators}
  end

  # �t�B���^�[��K�p���Ďd�|�����`�F�b�N����
  def check_entry(index)
    trade = entry_through_filter(index)
    return unless trade
    trade_with_first_stop(trade, index)
  end

  # �X�g�b�v��ݒ肷��
  def set_stop(position, index)
    position.stop = tightest_stop(position, index)
  end

  # �e��d�������[�������Ƀ`�F�b�N���A
  # �ŏ��Ɏ�d�����������������_�Ŏ�d����
  # ���ɂ́A��d�����𐧌����郋�[��������
  def check_exit(trade, index)
    @exits.each do |exit_rule|
      exit_filter = exit_rule.check_exit(trade, index)
      return if exit_filter == :no_exit
      return if trade.closed?
    end
  end

  private
  def each_rules
    [@entries, @exits, @stops, @filters].flatten.each do |rule|
      yield rule
    end
  end

  def entry_through_filter(index)
    case filter_signal(index)
    when :no_entry
      nil
    when :long_and_short
      check_long_entry(index) || check_short_entry(index)
    when :long_only
      check_long_entry(index)
    when :short_only
      check_short_entry(index)
    end
  end

  # ���ׂẴt�B���^�[���`�F�b�N���āA
  # �d�|������������i��
  def filter_signal(index)
    filters =
      @filters.map {|filter| filter.get_filter(index)}
    return :no_entry if filters.include?(nil) ||
      filters.include?(:no_entry) ||
      (filters.include?(:long_only) &&
       filters.include?(:short_only))
    return :long_only if filters.include?(:long_only)
    return :short_only if filters.include?(:short_only)
    :long_and_short
  end

  # �e�d�|�����[�������Ƀ`�F�b�N���A
  # �ŏ��ɔ����d�|�������������_�ŐV�K���g���[�h��Ԃ�
  # �d�|�����Ȃ����nil��Ԃ�
  def check_long_entry(index)
    check_entry_rule(:long, index)
  end

  # �e�d�|�����[�������Ƀ`�F�b�N���A
  # �ŏ��ɔ���d�|�������������_�ŐV�K���g���[�h��Ԃ�
  # �d�|�����Ȃ����nil��Ԃ�
  def check_short_entry(index)
    check_entry_rule(:short, index)
  end

  def check_entry_rule(long_short, index)
    @entries.each do |entry|
      trade =
        entry.send("check_#{long_short}_entry", index)
      return trade if trade
    end
    nil
  end

  # �ł������X�g�b�v�̒l�i�����߂�
  def tightest_stop(position, index)
    stops = [position.stop] +
      @stops.map {|stop| stop.get_stop(position, index)}
    stops.compact!
    if position.long?
      stops.max
    elsif position.short?
      stops.min
    end
  end

  # �d�|���̍ۂ̏����X�g�b�v��ݒ肷��
  def trade_with_first_stop(trade, index)
    return trade if @stops.empty?
    stop = tightest_stop(trade, index)
    # �܂��ЂƂ��X�g�b�v���Ȃ���Ύd�|���Ȃ�
    return unless stop
    trade.first_stop = stop
    trade.stop = stop
    trade
  end
end
