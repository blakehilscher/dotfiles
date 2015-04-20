module CLI
  class Project < Thor

    desc 'list', 'List all projects'

    def list
      puts "Projects: "
      puts Zoho::Project.all.collect { |p| "  #{p.project_name}\n" }.join
    end


    desc 'tasks PROJECT', "List a project's tasks"

    option :project, aliases: '-p'

    def tasks
      project = Zoho::Project.find(project_name)
      puts "Tasks for project: #{project.project_name}"
      puts Zoho::Task.all(project.project_id).collect { |p| "  #{p.task_name}\n" }.join
    end


    desc 'open PROJECT', 'Open a project'

    option :project, aliases: '-p'

    def open
      Zoho::Project.open(project_name)
    end


    private

    def project_name
      options[:project] || Zoho::Project.config[:project]
    end

  end
end