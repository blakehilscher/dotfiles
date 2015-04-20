module CLI
  class Time < Thor
    namespace 'time'

    class_option :open, type: :boolean, aliases: '-o'
    class_option :notes, aliases: '-n'


    desc 'start [-p project_name] [-t task_name]', 'Start the timer'

    option :project, aliases: '-p'
    option :task, type: :boolean, aliases: '-t'

    def start
      args = {
        project: project_name,
        task: task_name,
        notes: options[:notes],
        start_timer: true
      }
      Zoho::TimeEntry.new(args).save
      open_project
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

    private

    def open_project
      Zoho::Project.open(project_name) if options[:open]
    end

    def project_name
      options[:project] || folder_basename
    end

    def task_name
      options[:task] || git_branch_name
    end

    def folder_basename
      File.basename(File.expand_path('.'))
    end

    def git_branch_name
      `git branch | grep '*'`.gsub('* ', '').strip.rstrip
    end

  end
end