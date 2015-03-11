require 'net/http'
require 'json'
require_relative './config.rb'
require_relative './request.rb'

class Zoho

  attr_reader :options

  def initialize(options={})
    @options = options.with_indifferent_access
    Zoho::Request.default_config = config
  end

  def time_entry(payload)
    Zoho::Request.new(endpoint: '/projects/timeentries').post(payload)
  end

  def projects
    Zoho::Request.new(endpoint: 'projects').get
  end

  def config
    @config ||= Zoho::Config.new(config_path).load
  end

  def config_path
    @config_path ||= options[:config_path] || "#{ENV['HOME']}/.zoho"
  end
end

puts Zoho.new.projects