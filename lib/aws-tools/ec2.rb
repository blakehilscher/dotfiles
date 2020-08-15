require 'active_support/core_ext/hash'
require 'active_support/core_ext/integer/time'
require 'json'
require 'fileutils'
require 'ostruct'

require_relative './server'

module AwsTools
  class EC2

    def servers
      @servers ||= fetch_servers
    end

    def instances
      @instances ||= describe_instances
    end

    private

    def fetch_servers
      servers = []
      instances['Reservations'].each do |reservation|
        reservation['Instances'].each do |instance|
          servers << AwsTools::Server.new(instance)
        end
      end
      servers.reject { |s| s.name.blank? || s.ip.blank? }.sort_by { |s| s.name }
    end

    def describe_instances
      cache_path = File.join(ENV['HOME'], '.aws/')
      cache_file = File.join(cache_path, '.describe-instances-cache')
      # ensure dir exists
      FileUtils.mkdir_p(cache_path) unless Dir.exists?(cache_path)
      # ensure cache is recent
      if File.exists?(cache_file) && File.ctime(cache_file) > 15.seconds.ago
        payload = File.read(cache_file)
      else
        payload = %x(aws ec2 describe-instances)
        File.write(cache_file, payload)
      end
      # onwards
      JSON.parse(payload)
    rescue
      FileUtils.rm(cache_file) if File.exists?(cache_file)
      raise 
    end

  end
end