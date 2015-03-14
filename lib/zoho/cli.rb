require_relative './all.rb'
require 'thor'

class CLI < Thor

  desc 'projects', 'zoho projects'

  def projects
    puts "Projects: "
    puts Zoho::Project.all.collect { |p| "  #{p.project_name}\n" }.join
  end

  desc 'tasks PROJECT', 'zoho tasks DesignProject'

  def tasks(project_name)
    project = Zoho::Project.find(project_name)
    puts "Tasks for project: #{project.project_name}"
    puts Zoho::Task.all(project.project_id).collect { |p| "  #{p.task_name}\n" }.join
  end

  desc 'open PROJECT', 'zoho open DesignProject'

  def open(project_name)
    project = Zoho::Project.find(project_name)
    Zoho.bash(%Q{open "https://invoice.zoho.com/app#/timesheet/projects/#{project.project_id}"})
  end

  desc 'log PROJECT TASK DURATION FREQUENCY', 'zoho log DesignProject wireframes 2 hours'

  option :notes, aliases: '-n'
  option :open, type: :boolean, aliases: '-o'

  def log(project, task, time, frequency)
    args = {
        project: project,
        task: task,
        time: time,
        frequency: frequency,
        notes: options[:notes]
    }
    Zoho::TimeEntry.new(args).save
    open(project) if options[:open]
  end

  desc 'time PROJECT TASK', 'zoho time DesignProject wireframes'

  option :notes, aliases: '-n'
  option :open, type: :boolean, aliases: '-o'

  def time(project, task)
    args = {
        project: project,
        task: task,
        notes: options[:notes],
        start_timer: true
    }
    Zoho::TimeEntry.new(args).save
    open(project) if options[:open]
  end

  desc 'time_stop', 'Stop the current timer'
  option :notes, aliases: '-n'

  def time_stop
    Zoho::TimeEntry.stop_timer(options)
  end

end