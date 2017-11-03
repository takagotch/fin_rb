# coding: Windows-31J

require "./lib/stock"
require "./lib/stock_list_loader"
require "date"

# �e�L�X�g�f�[�^����Stcok�N���X�̃I�u�W�F�N�g�𐶐�����N���X
class TextToStock
  attr_writer :from, :to

  def initialize(params)
    @data_dir       = params[:data_dir] || "data"
    @stock_list     = params[:stock_list] || raise("�������X�g���w�肵�Ă�������")
    @market_section = params[:market_section]
    @list_loader = StockListLoader.new("#{@data_dir}/#{@stock_list}")
  end

  # ���I�u�W�F�N�g�𐶐�����
  def generate_stock(code)
    index = @list_loader.codes.index(code)
    stock = Stock.new(code,
                      market(index),
                      @list_loader.units[index])
    add_prices_from_data_file(stock)
    stock
  end

  # �������X�g�ɂ�������ɂ��āA
  # �f�[�^�f�B���N�g�����ɂ��銔���f�[�^����
  # ���ԂɊ��I�u�W�F�N�g��Ԃ��C�e���[�^
  def each_stock
    @list_loader.filter_by_market_section(*@market_section).codes.each do |code|
       if File.exist?("#{@data_dir}/#{code}.txt")
         yield generate_stock(code)
       end
    end
  end

  private
  def market(index)
    section = @list_loader.market_sections[index]
    case section
    when /����|�}�U�[�Y/
      :t
    when /��/
      :n
    when /��/
      :f
    when /�D/
      :s
    end
  end

  def add_prices_from_data_file(stock)
    lines = File.readlines("#{@data_dir}/#{stock.code}.txt")
    fi = from_index(lines)
    ti = to_index(lines)
    return if fi.nil? || ti.nil?
    lines[fi..ti].each do |line|
      data = line.split(",")
      date = data[0]
      prices_and_volume = data[1..5].map {|d| d.to_i}
      stock.add_price(date, *prices_and_volume)
    end
  end

  def from_index(lines)
    return 0 unless @from
    @formatted_from ||= Date.parse(@from).to_s.gsub("-", "/")
    lines.index {|line| line[0..9] >= @formatted_from}
  end

  def to_index(lines)
    return lines.size unless @to
    @formatted_to ||= Date.parse(@to).to_s.gsub("-", "/")
    lines.rindex {|line| line[0..9] <= @formatted_to}
  end
end
