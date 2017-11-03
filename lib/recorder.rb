# coding: Windows-31J

require "./lib/trade"
require "./lib/array"
require "./lib/stats"
require "fileutils"
require "csv"

# ����̋L�^���s���N���X
class Recorder
  attr_writer :record_dir

  def initialize(record_dir = nil)
    @record_dir = record_dir
  end

  # 1�����̎�����L�^����
  def record_a_stock(trades)
    code = trades[0].stock_code
    ensure_close("#{code}.csv") do
      file_name = "#{@record_dir}/#{code}.csv"
      CSV.open(file_name, "w") do |csv_file|
        csv_file << items_for_a_stock.values
        trades.each do |trade|
          one_trade = items_for_a_stock.keys.map do |attr|
            trade.send(attr) || "-"
          end
          csv_file << one_trade
        end
      end
    end
  end

  # �������Ƃ̓��v�̈ꗗ�\�̍쐬
  def record_stats_for_each_stock(results)
    ensure_close("_stats_for_each_stock.csv") do
      CSV.open("#{@record_dir}/_stats_for_each_stock.csv", "w") do |csv_file|
        csv_file << stats_items.values.unshift("�R�[�h")
        results.each do |trades|
          csv_file << stats_array(trades).unshift(trades[0].stock_code)
        end
      end
    end
  end

  # ���ׂẴg���[�h�̓��v
  def record_stats(results)
    ensure_close("_stats.csv") do
      CSV.open("#{@record_dir}/_stats.csv", "w") do |csv_file|
        csv_file << stats_items.values
        csv_file << stats_array(results.flatten)
      end
    end
  end

  # �ݒ�t�@�C�����R�s�[����
  def record_setting(file_name)
    FileUtils.cp file_name, @record_dir + "/_setting.rb"
  end

  # ���ʕۑ��p�̃t�H���_�[�����
  def create_record_folder
    if Dir.exist? @record_dir
      puts "�L�^�t�H���_ #{@record_dir} �͂��łɑ��݂��܂��B�㏑�����܂����H y/n"
      yes? {puts "�㏑�����܂�"}
    else
      puts "�L�^�t�H���_ #{@record_dir} �͑��݂��܂���B�V�������܂����H y/n"
      yes? {FileUtils.mkdir_p @record_dir}
    end
  end

  private
  def items_for_a_stock
    { :trade_type => "������",
      :entry_date => "�����t",
      :entry_price => "���l",
      :volume => "����",
      :first_stop => "�����X�g�b�v",
      :exit_date => "�o���t",
      :exit_price => "�o�l",
      :profit => "���v(�~)",
      :r_multiple => "R�{��",
      :percentage_result => "%���v",
      :length => "����"}
  end

  def stats_items
    { :sum_profit => "�����v",
      :wins => "������", :losses => "������",
      :draws => "������",
      :winning_percentage => "����",
      :average_profit => "���ϑ��v",
      :profit_factor => "PF",
      :sum_r => "��R�{��", :average_r => "����R�{��",
      :sum_percentage => "�����v��",
      :average_percentage => "���ϑ��v��",
      :average_length => "���ϊ���"}
  end

  def stats_array(trades)
    stats = Stats.new(trades)
    stats_items.keys.map do |stats_name|
      stats.send(stats_name) || "-"
    end
  end

  def ensure_close(file_name)
    begin
      yield
    rescue Errno::EACCES
      puts "#{file_name} �����̃v���O�����ŏ������݋֎~�ŊJ����Ă���\��������܂��B" +
        "�t�@�C������Ă���G���^�[�L�[�������Ă��������B"
      while $stdin.gets
        retry
      end
    end
  end

  def yes?
    while answer = $stdin.gets
      if answer =~ /^[yY]/
        yield
        break
      elsif answer =~ /^[nN]/
        puts "�I�����܂�"
        exit
      else
        puts "y �i�͂��j�� n �i�������j�ł�������������"
      end
    end
  end
end
