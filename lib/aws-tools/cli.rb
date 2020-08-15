require 'thor'

require 'parallel'
require 'net/ssh'

require_relative './ec2'

module CLI
  class Base < Thor

    desc "ssh SUBCOMMAND", "execute ssh commands across instances"

    option :debug, type: :boolean
    option :match, aliases: '-m', type: :array
    option :exclude, aliases: '-e', type: :array
    option :identity, aliases: '-i'
    option :command, aliases: '-c'
    option :list, aliases: '-l', type: :boolean
    option :first, aliases: '-f', type: :boolean
    option :user, aliases: '-u'

    def ssh
      command = options[:command]
      if options[:list]
        puts servers.collect(&:describe).join("\n")
      elsif command.present?
        ssh_command(command)
      elsif server_matcher.present? || options[:exclude].present?
        ssh_connect
      end
    rescue => err
      FileUtils.rm('/Users/blake/.aws/.describe-instances-cache') if File.exists?('/Users/blake/.aws/.describe-instances-cache')
      raise err
    end

    private

    def ssh_command(command)
      if options[:first]
        ssh_command_single(command)
      else
        ssh_command_many(command)
      end
    end

    def ssh_command_many(command)
      sessions = []
      channels = []
      semaphore = Mutex.new
      # start processes
      Parallel.each(servers, in_threads: servers.count) do |server|
        Net::SSH.start(server.ip, user, keys: [identity]) do |ssh|
          ssh.open_channel do |channel|
            channel.exec(command)
            channel.on_data do |c, data|
              semaphore.synchronize { $stdout.print(data) }
            end
            channel.on_extended_data do |c, type, data|
              $stderr.print data
            end
            semaphore.synchronize { channels << channel }
          end
          semaphore.synchronize { sessions << ssh }
        end
      end
      # wait for termination
      channels.each do |c|
        c.wait
      end

    end

    def ssh_command_single(command)
      server = servers.first
      bash(%Q{ssh #{user}@#{server.ip} -i #{identity} "#{command}"})
    end

    def kill_processes(processes)
      processes.each do |p|
        log "killing #{p.pid}"
        Process.kill("INT", p.pid)
      end
    end

    def ssh_connect
      if servers.length == 1
        bash ssh_string(servers[0].ip)
      elsif servers.length > 1
        log "# connecting to #{servers.count} servers"
        servers.each { |s| bin_bash newtab ssh_string(s.ip) }
      else
        log "No servers matched: #{server_matcher}"
      end
    end

    def servers
      @servers ||= resolve_servers
    end

    def resolve_servers
      servers = ec2.servers
      server_matcher.to_a.each do |arg|
        matcher = arg.downcase
        servers = servers.select do |s|
          ip_matcher = parse_ip(arg)
          s.name == arg || s.private_ip.match(ip_matcher) || s.ip.match(ip_matcher) || s.match_name.match(matcher)
        end
      end
      options[:exclude].to_a.each do |arg|
        matcher = arg.downcase
        servers = servers.reject do |s|
          ip_matcher = parse_ip(arg)
          s.name == arg || s.private_ip.match(ip_matcher) || s.ip.match(ip_matcher) || s.match_name.match(matcher)
        end
      end
      if options[:first]
        servers = [servers.first]
      end
      servers
    end

    def parse_ip(arg)
      arg.to_s.gsub('ip-','').gsub('-','.')
    end

    def newtab(c)
      %Q{newtab "#{c}"}
    end

    def server_matcher
      @server_matcher ||= resolve_server_matcher
    end

    def resolve_server_matcher
      matcher = options[:match].to_a
      if matcher[0] =~ /@/
        parts = matcher[0].split('@')
        @user = parts[0]
        matcher[0] = parts[1]
      end
      matcher
    end

    def ssh_string(ip, command=nil)
      str = %Q{ssh #{user}@#{ip} -o "StrictHostKeyChecking no" -i #{identity}}
      str += %Q{ "#{command}"} if command.present?
      str
    end

    def bin_bash(c)
      bash(%Q{/bin/bash -l -c 'cd #{ENV['HOME']} && #{c}'})
    end

    def ec2
      @ec2 ||= AwsTools::EC2.new
    end

    def user
      @user || options[:user] || ENV['AWS_USER'] || 'ubuntu'
    end

    def identity
      options[:identity] || ENV['AWS_IDENTITY_PATH']
    end

    def bash_io(c)
      log(c)
      IO.popen(c)
    end

    def bash(c)
      log(c)
      system(c)
    end

    def log(m)
      puts(m) if options[:debug]
    end

  end
end