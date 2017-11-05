# coding: Windows-31J

require "open-uri"
require "date"

# Yahoo!�t�@�C�i���X���犔���f�[�^���_�E�����[�h����N���X
class StockDataGetter
  attr_accessor :data_dir

  def initialize(from, to, market)
    @from_date = Date.parse(from)
    @to_date   = Date.parse(to)
    @market = market
    @data_dir = "data"
  end

  # �����f�[�^�̐V�K�擾
  def get_price_data(code)
    @code = code
    save_to_file(prices_text)
  end

  # �����f�[�^�̓��X�X�V
  def update_price_data(code)
    @code = code
    if File.exist?(data_file_name)
      get_from_date
      append_to_file(prices_text)
    else
      save_to_file(prices_text)
    end
  end

  private
  # �t�@�C���ɋL�^����镶����
  def prices_text
    prices = get_price_data_from_historical_data_pages
    return if prices.empty?
    prices_to_text(prices)
  end

  # ���n��f�[�^�̃y�[�W��ǂݍ���
  def get_price_data_from_historical_data_pages
    page_num = 1
    prices = []
    begin
      url = url_for_historical_data(page_num)
      begin
        text = open(url).read.encode("Windows-31J", :undef => :replace)
      rescue EOFError
        return []
      end
      prices += text.scan(reg_prices)
      page_num += 1
    end  while text =~ %r!����</a></ul>!
    prices
  end

  # ���n��f�[�^��URL
  def url_for_historical_data(page_num)
    "http://info.finance.yahoo.co.jp/history/" +
      "?code=#{@code}.#{@market}" +
      "&sy=#{@from_date.year}" +
      "&sm=#{@from_date.month}&sd=#{@from_date.day}" +
      "&ey=#{@to_date.year}" +
      "&em=#{@to_date.month}&ed=#{@to_date.day}" +
      "&tm=d&p=#{page_num}"
  end

  # �����f�[�^�\���犔���f�[�^�����o�����߂�
  # ���K�\���p�^�[��
  def reg_prices
    %r!<td>(\d{4}�N\d{1,2}��\d{1,2}��)</td><td>((?:\d|,)+(?:\.\d+)?)</td><td>((?:\d|,)+(?:\.\d+)?)</td><td>((?:\d|,)+(?:\.\d+)?)</td><td>((?:\d|,)+(?:\.\d+)?)</td><td>((?:\d|,)+)</td><td>((?:\d|,)+(?:\.\d+)?)</td>!
  end

  # �����f�[�^�̔z��𕶎���ɕϊ�
  def prices_to_text(prices)
    new_prices = prices.reverse.map do |price|
      # price[0]�͓��t
      # �N�����̕�������菜��"/"�ŋ�؂�
      price[0].gsub!(/[�N��]/, "\/")
      price[0].gsub!(/��/, "")
      # 1���̌������0�Ŏn�܂�񌅂̐�����
      price[0].gsub!(%r!/(\d)/!, '/0\1/')
      price[0].gsub!(%r!/(\d)$!, '/0\1')
      # price[1..6]�͒l�i�Əo����
      # �����̊Ԃɂ���J���}����菜��
      price[1..6].each{|price| price.gsub!(",", "")}
      price.join(",")
    end
    new_prices.join("\n")
  end

  def data_file_name
    "#{@data_dir}/#{@code}.txt"
  end

  # �t�@�C�����̍ŏI���̗�����V�����J�n���Ƃ���
  def get_from_date
    last_date = File.readlines(data_file_name).last[0..9]
    @from_date = Date.parse(last_date).next
  end

  # �f�[�^���e�L�X�g�ɕۑ�
  def save_to_file(prices_text)
    save(prices_text, "w")
  end

  # �����̃t�@�C���Ƀf�[�^��ǉ�
  def append_to_file(prices_text)
    save(prices_text, "a")
  end

  def save(prices_text, open_mode)
    return unless prices_text
    File.open(data_file_name, open_mode) do |file|
      file.puts prices_text
    end
    puts @code
  end
end
