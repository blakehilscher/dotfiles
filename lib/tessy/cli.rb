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
      Tessy::TessyFile.new(file).process
    end
  end

  desc 'check', 'tessy check file1 file2 ...'

  option :invalid, type: :boolean
  option :valid, type: :boolean

  def check(*files)
    files.each do |file_path|
      file = Tessy::TessyFile.new(file_path)
      message = file.check.collect { |key, value| "#{key} => #{value}\n" }.join + "\n----\n"
      if options[:invalid]
        puts message if file.date.blank?
      elsif options[:valid]
        puts message if file.date.present?
      else
        puts message
      end
    end
  end

end