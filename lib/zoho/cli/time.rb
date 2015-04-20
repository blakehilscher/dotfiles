module CLI
  class Time < Thor
    namespace 'time'

    class_option :open, type: :boolean, aliases: '-o'
    class_option :notes, aliases: '-n'


    desc 'start [-p project_name] [-t task_name]', 'Start the timer. Default values: { project_name: Current working directory, task_name: Current git branch }'

    option :project, aliases: '-p'
    option :task, type: :boolean, aliases: '-t'

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