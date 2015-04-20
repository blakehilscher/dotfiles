module CLI
  class Timesheet < Thor
    namespace 't'

    class_option :open, type: :boolean, aliases: '-o'

    desc 'list', 'List all projects'

    def list
      puts "# Projects"
      puts Zoho::Project.all.collect { |p| "#{p.project_name}\n" }.join
    end


    desc 'tasks PROJECT', "List a project's tasks"

    option :project, aliases: '-p'

    def tasks
      project = Zoho::Project.find(project_name)
      puts "# Project: #{project.project_name}"
      puts Zoho::Task.all(project.project_id).collect { |p| "#{p.task_name}\n" }.join
    end


    desc 'open PROJECT', 'Open a project'

    option :project, aliases: '-p'

    def open
      Zoho::Project.open(project_name)
    end


    desc 'start [-p project_name] [-t task_name]', 'Start the timer. Default values: { project_name: Current working directory, task_name: Current git branch }'

    option :project, aliases: '-p'
    option :task, type: :boolean, aliases: '-t'
    option :notes, aliases: '-n'

    def start
      if task_name.blank?
        puts 'task_name is blank. Is the current directory a git repository?'
      else
        args = {
          project: project_name,
          task: task_name,
          notes: options[:notes],
          start_timer: true
        }
        Zoho::TimeEntry.new(args).save
        open_project
      end
    end


    desc 'stop', 'Stop the active timer'

    def stop
      Zoho::TimeEntry.stop_timer(options)
      open_project
    end


    desc 'log DURATION FREQUENCY', 'zoho log 2 hours [-p project_name] [-t task_name]'

    option :notes, aliases: '-n'
    option :open, type: :boolean, aliases: '-o'

    def log(time, frequency)
      args = {
        project: project_name,
        task: task_name,
        time: time,
        frequency: frequency,
        notes: options[:notes]
      }
      Zoho::TimeEntry.new(args).save
    end


    desc 'open', 'Open a project'

    def open
      Zoho::Project.open(project_name)
    end

    private

    def open_project
      Zoho::Project.open(project_name) if options[:open]
    end

    def project_name
      options[:project] || Zoho::Project.config[:project] || folder_basename
    end

    def task_name
      options[:task] || Zoho::Project.config[:task] || git_branch_name
    end

    def folder_basename
      @folder_basename ||= File.basename(File.expand_path('.'))
    end

    def git_branch_name
      @git_branch_name ||= `git branch | grep '*'`.gsub('* ', '').strip.rstrip
    end

  end
end