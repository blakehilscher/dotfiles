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

  option :force, type: :boolean
  option :dry, type: :boolean
  option :verbose, type: :boolean, aliases: ['-v']

  def process(*file_paths)
    Parallel.map(file_paths, in_processes: 8) do |file_path|
      Tessy::TessyFile.new(file_path, options).process
    end
  end

  desc 'check', 'tessy check file1 file2 ...'

  option :invalid, type: :boolean
  option :valid, type: :boolean

  option :force, type: :boolean
  option :dry, type: :boolean
  option :verbose, type: :boolean, aliases: ['-v']

  def check(glob)
    files = Dir.glob(glob).to_a.flatten
    Parallel.map(files, in_processes: 8) do |file_path|
      file = Tessy::TessyFile.new(file_path, options)
      check = file.check
      if check.present?
        message = check.collect { |key, value| "#{key} => #{value}\n" }.join + "\n----"
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

end