module AwsTools
  class Server

    attr_reader :instance

    def initialize(instance)
      @instance = instance
    end

    def running?
      instance['State']['Name'] == 'running'
    end

    def describe
      [ip, private_ip, name].join(' | ')
    end

    def ssh_user
      tags['ssh_user']
    end

    def ip
      instance['PublicIpAddress']
    end

    def private_ip
      instance['PrivateIpAddress']
    end

    def name
      tags['Name']
    end

    def tags
      unless instance_variable_defined?(:@tags)
        output = {}.with_indifferent_access
        instance['Tags'].each do |item|
          output[item['Key']] = item['Value']
        end
        @tags = output
      end
      @tags
    end

    def match_name
      name.to_s.downcase.gsub(/\s+/, '-')
    end

  end

end