require 'net/http'
require 'json'
require_relative './config.rb'
require_relative './request.rb'
require_relative './time_entry.rb'

class Zoho

  attr_reader :options

  def initialize(options={})
    @options = options.with_indifferent_access
    Zoho::Request.default_config = config
  end

  def log(project, task, *times)
    Zoho::TimeEntry.new(project: project, task: task, time: times)
  end

  def config
    @config ||= Zoho::Config.new(config_path).load
  end

  def config_path
    @config_path ||= options[:config_path] || "#{ENV['HOME']}/.zoho"
  end
end

z = Zoho.new

command = ARGV.shift

if command == 'log'
  z.log(*ARGV)
else
  puts %Q{
  Available commands:
    log
  }
end
