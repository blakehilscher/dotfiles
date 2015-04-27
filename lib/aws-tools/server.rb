module AwsTools
  class Server

    attr_reader :instance

    def initialize(instance)
      @instance = instance
    end

    def describe
      [ip, private_ip, name].join(' | ')
    end

    def ip
      instance['PublicIpAddress']
    end

    def private_ip
      instance['PrivateIpAddress']
    end

    def name
      instance['Tags'].find { |t| t['Key'] == 'Name' }['Value'] rescue ''
    end

    def match_name
      name.to_s.downcase.gsub(/\s+/, '-')
    end

  end

end