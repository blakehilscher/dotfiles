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
      zoho log project_name task_name 2 hours         # Create a timesheet entry
      zoho open project_name                          # Open a project in your browser
      zoho projects                                   # List projects
      zoho tasks project_name                         # List tasks for a project
    }
  end

end

z = Zoho.new
command = ARGV.shift

begin
  if command == 'log'
    z.log(*ARGV)
  elsif command == 'open'
    project = Zoho::Project.find(ARGV[0])
    `open "https://invoice.zoho.com/app#/timesheet/projects/#{project.project_id}"`
  elsif command == 'projects'
    puts "Projects: "
    puts Zoho::Project.all.collect { |p| "  #{p.project_name}\n" }.join
  elsif command == 'tasks'
    project = Zoho::Project.find(ARGV[0])
    puts "Tasks for project: #{project.project_name}"
    puts Zoho::Task.all(project.project_id).collect { |p| "  #{p.task_name}\n" }.join
  else
    z.describe
  end

rescue => err
  puts "\nAn error occurred:\n\n"
  puts err
  puts err.backtrace[0..1].join("\n")
  z.describe
end