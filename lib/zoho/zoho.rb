require 'yaml'
require 'net/http'
require 'json'
require_relative './config.rb'
require_relative './request.rb'
require_relative './time_entry.rb'
require_relative './project.rb'
require_relative './task.rb'

class Zoho
  class << self

    attr_accessor :config

    def config
      @config ||= Zoho::Config.new("#{ENV['HOME']}/.zoho").load
    end

  end
end