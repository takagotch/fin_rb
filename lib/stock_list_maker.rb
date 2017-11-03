# coding: Windows-31J

require "open-uri"

# Yahoo�̖������y�[�W��������擾���A
# �������X�g�����N���X
# �،��R�[�h�A���s��A�P�������E�����P�ʂ��܂܂��
class StockListMaker
  attr_accessor :data_dir, :file_name

  def initialize(market)
    @market = market
    @data_dir = "data"
    @stock_info = []
  end

  # �������̎擾
  def get_stock_info(code)
    page = open_page(code)
    return unless page
    text = page.read.encode("Windows-31J", :undef => :replace)
    data = parse(text)
    data[:code] = code
    return unless data[:market_section]
    puts code
    @stock_info << data
  end

  # �������̕ۑ�
  def save_stock_list
    File.open(@data_dir + "/" + @file_name, "w") do |file|
      @stock_info.each do |data|
        file.puts [data[:code], data[:market_section], data[:unit]].join(",")
      end
    end
  end

  private
  # �������y�[�W���J��
  def open_page(code)
    begin
      open("http://stocks.finance.yahoo.co.jp/stocks/detail/?code=#{code}.#{@market}")
    rescue OpenURI::HTTPError
      return
    end
  end

  # HTML����������𔲂��o��
  def parse(text)
    data = Hash.new
    sections = []
    reg_market = /"stockMainTabName">([^< ]+)</
    reg_unit = %r!<dd class="ymuiEditLink mar0"><strong>((?:\d|,)+|---)</strong>��</dd>!
    text.lines do |line|
      if line =~ reg_market
        sections << $+
      elsif line =~ reg_unit
        data[:market_section] = sections[0]
        data[:unit] = get_unit($+)
        return data
      end
    end
    data
  end

  # �P�ʊ����𓾂�
  def get_unit(str)
    if str == "---"
      "1"
    else
      str.gsub(/,/,"")
    end
  end
end
