require 'net/http'
require 'json'
require_relative './config.rb'
require_relative './request.rb'
require_relative './time_entry.rb'

class Zoho

  class << self

    attr_accessor :config

    def config
      @config ||= Zoho::Config.new("#{ENV['HOME']}/.zoho").load
    end

  end

  attr_reader :options

  def initialize(options={})
    @options = options.with_indifferent_access
  end

  def log(project, task, *times)
    Zoho::TimeEntry.new(project: project, task: task, time: times).save
  end


  def describe
    puts %Q{
    Available commands:
      log project_name task_name 2 hours
    }
  end

end

z = Zoho.new
command = ARGV.shift

begin
  if command == 'log'
    z.log(*ARGV)
  else
    z.describe
  end

rescue => err
  puts "\nAn error occurred:\n\n"
  puts err
  puts err.backtrace[0..1].join("\n")
  z.describe
end