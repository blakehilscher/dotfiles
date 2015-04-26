module CLI
  class Timesheet < Thor
    namespace 't'

    class_option :open, type: :boolean, aliases: '-o'


    desc 'active', 'Output the active project'

    def active
      if Zoho.config[:active_timesheet].present?
        puts Zoho.config[:active_timesheet]
      else
        puts "No active timesheet."
      end
    end


    desc 'list', 'List all projects'

    def list
      puts "# Projects"
      puts Zoho::Project.all.collect { |p| "#{p.project_name}\n" }.join
    end


    desc 'tasks [-p project_name]', "List a project's tasks"
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


    desc 'commit [-T begin_time] [-p project_name] [-t task_name] [-n notes]', 'Stop current timer, save commits, and start a new timer.'
    option :project, aliases: '-p'
    option :task, type: :boolean, aliases: '-t'
    option :notes, aliases: '-n'
    option :begin_time, aliases: '-T'

    def commit
      stop
      start
    end


    desc 'start [-T begin_time] [-p project_name] [-t task_name] [-n notes]', 'Start a project timer.'
    option :project, aliases: '-p'
    option :task, type: :boolean, aliases: '-t'
    option :notes, aliases: '-n'
    option :begin_time, aliases: '-T'

    def start
      if task_name.blank?
        puts 'task_name is blank. Is the current directory a git repository?'
      else
        params = timesheet_params.merge({ start_timer: true })
        Zoho::TimeEntry.new(params).save
        open_project
      end
    end


    desc 'stop', 'Stop the active timer'

    def stop
      if Zoho.config[:active_timesheet].present?
        Dir.chdir(Zoho.config[:active_timesheet]) do 
          puts "Stopping timer for: #{project_name}"
          Zoho::TimeEntry.stop_timer(timesheet_params)
          open_project
        end
      else
        puts "No active timesheet."
      end
    end


    desc 'log BEGIN_TIME [-p project_name] [-t task_name] [-n notes]', 'Log an entry. EG: zoho log 2.hours.ago'
    option :project, aliases: '-p'
    option :task, type: :boolean, aliases: '-t'
    option :notes, aliases: '-n'

    def log(begin_time)
      params = timesheet_params.merge({ begin_time: begin_time })
      Zoho::TimeEntry.new(params).save
    end


    desc 'open [-p project_name]', 'Open a project'
    option :project, aliases: '-p'

    def open
      Zoho::Project.open(project_name)
    end


    private

    def timesheet_params
      {
        project: project_name,
        task: task_name,
        notes: options[:notes],
        begin_time: options[:begin_time]
      }
    end

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