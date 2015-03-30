require_relative './all.rb'
require 'thor'
require 'date'
require 'time'
require 'pry'
require 'active_support/all'
require 'fileutils'
require 'parallel'
require 'chronic'

class CLI < Thor

  desc 'process', 'tessy process file1 file2 ...'

  def process(*files)
    Parallel.map(files, in_processes: 6) do |file|
      if File.exists?(file)
        puts "read #{File.basename(file)}"
        ext = File.basename(file).split('.').last
        words = tesseract(file)
        date = extract_date(file, words)
        if date.present?
          title = extract_title(words)
          filename = "#{date},#{title}.#{ext}"
          if file =~ /^Scan/i
            puts "rename #{filename}"
            rename_file(file, filename)
            write_txt(filename, words)
          else
            puts "update #{file}.txt"
            write_txt(file, words)
          end
        else
          puts "invalid #{file}"
          write_txt(file, words)
        end
      end
    end
  end

  desc 'test_date', 'tessy test_date file1 file2 ...'

  def test_date(*files)
    files.each do |file|
      date = extract_date(file, File.read(file))
      puts "#{file} - #{date}"
    end
  end

  private

  def rename_file(original, filename)
    unless original == filename
      FileUtils.mv(original, filename)
    end
  end

  def write_txt(filename, string)
    name = "#{filename}.txt"
    File.write(name, string)
  end

  def extract_title(string)
    string.split("\n").reject(&:blank?).first.parameterize
  end

  def extract_date(filename, string)
    full_months = 'january|february|march|april|may|june|july|august|september|october|november|december'
    short_months = 'jan|feb|mar|apr|may|jun|jul|aug|sep|sept|oct|nov|dec'
    sep = '[-\/]'
    long_year = '[12][09][0-9][0-9]'
    months = "(#{full_months}|#{short_months})"
    formats = {
        /[01][0-9]#{sep}[0-3][0-9]#{sep}\d{2}/ => '%m/%d/%y',
        /[01][0-9]#{sep}[0-3][0-9]#{sep}#{long_year}/ => '%m/%d/%Y',
        /#{months} \d{1,2}, #{long_year}/i => '%b %d, %Y',
        /#{months} \d{1,2} \d{2}/i => '%b %d %y',
        /\d{1,2}#{sep}#{long_year}/i => '%m/%Y',
        /#{months} \d{1,2}#{sep}\d{2}/i => '%b %d/%y',
        /\d{1,2} #{months} \d{2}/i => '%d %b %y',
        /\d{1,2} #{months} #{sep} \d{2}/i => '%d %b - %y',
        /#{months} \d{1,2},#{long_year}/i => '%b %d,%Y',
    }
    formats.each do |pattern, format|
      data = string.match(pattern)
      if data
        begin
          return Date.strptime(data[0], format)
        rescue
          return Chronic.parse(data[0]).try(:to_date)
        end
      end
    end
    false
  end

  def tesseract(file)
    bash %Q{tesseract "#{file}" stdout}
  end

  def bash(cmd)
    `#{cmd}`.strip
  end

end