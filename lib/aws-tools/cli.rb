require 'thor'

require 'parallel'
require 'net/ssh'

require_relative './ec2'

module CLI
  class Base < Thor

    desc "ssh SUBCOMMAND", "execute ssh commands across instances"

    option :debug, type: :boolean
    option :match, aliases: '-m', type: :array
    option :identity, aliases: '-i'
    option :list, aliases: '-l', type: :boolean

    def ssh(command=nil)
      if options[:list]
        puts servers.collect(&:describe).join("\n")
      elsif command.present?
        ssh_command(command)
      elsif options[:match].present?
        ssh_connect
      end
    end

    private

    def ssh_command(command)
      sessions = []
      channels = []
      semaphore = Mutex.new
      # start processes
      Parallel.each(servers, in_threads: servers.count) do |server|
        Net::SSH.start(server.ip, user, keys: [identity]) do |ssh|
          puts 'starting ssh'
          ssh.open_channel do |channel|
            channel.exec(command)
            channel.on_data do |c, data|
              $stdout.print data
            end
            channel.on_extended_data do |c, type, data|
              $stderr.print data
            end
            channel.on_close do |ch|
              puts "channel is closing!"
            end
            semaphore.synchronize { channels << channel }
          end
          semaphore.synchronize { sessions << ssh }
        end
      end
      # wait for termination
      channels.each do |c|
        puts 'waiting'
        c.wait
      end
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
        log "No servers matched: #{options[:match]}"
      end
    end

    def servers
      @servers ||= resolve_servers
    end

    def resolve_servers
      servers = ec2.servers
      options[:match].to_a.each do |arg|
        matcher = arg.downcase
        servers = servers.select do |s|
          s.name == arg || s.private_ip.match(arg) || s.ip.match(arg) || s.match_name.match(matcher)
        end
      end
      servers
    end

    def newtab(c)
      %Q{newtab "#{c}"}
    end

    def ssh_string(ip, command=nil)
      str = %Q{ssh #{user}@#{ip} -i #{identity}}
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
      options[:user] || 'ubuntu'
    end

    def identity
      options[:identity] || "#{ENV['HOME']}/.ssh/callpixels_deploy.pem"
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