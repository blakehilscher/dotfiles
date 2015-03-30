require_relative './all.rb'
require 'thor'

class CLI < Thor

  desc 'process', 'tessy process file1 file2 ...'

  def process(*files)
    puts files.join("\n")
  end

end