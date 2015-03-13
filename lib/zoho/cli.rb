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

  desc 'log PROJECT TASK DURATION', 'zoho log DesignProject wireframes 2 hours'

  def log(project, task, *times)
    Zoho::TimeEntry.new(project: project, task: task, time: times).save
  end

  desc 'open PROJECT', 'zoho open DesignProject'

  def open(project_name)
    project = Zoho::Project.find(project_name)
    `open "https://invoice.zoho.com/app#/timesheet/projects/#{project.project_id}"`
  end

end