require 'yaml'
require 'net/http'
require 'json'
require_relative './config.rb'
require_relative './request.rb'
require_relative './time_entry.rb'
require_relative './project.rb'
require_relative './task.rb'


module Zoho
  class << self

    attr_accessor :config

    def config
      @config ||= configuration.load
    end

    def configuration
      @configuration ||= Zoho::Config.new("#{ENV['HOME']}/.zoho")
    end

    def reload
      remove_instance_variable('@config') if @config
      remove_instance_variable('@configuration') if @configuration
    end

    def bash(c)
      puts c
      %x{#{c}}.strip
    end

  end
end