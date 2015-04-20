module CLI
  class Project < Thor

    desc 'list', 'List all projects'

    def list
      puts "Projects: "
      puts Zoho::Project.all.collect { |p| "  #{p.project_name}\n" }.join
    end

    desc 'tasks PROJECT', "List a project's tasks"

    def tasks(project_name)
      project = Zoho::Project.find(project_name)
      puts "Tasks for project: #{project.project_name}"
      puts Zoho::Task.all(project.project_id).collect { |p| "  #{p.task_name}\n" }.join
    end

    desc 'open PROJECT', 'Open a project'

    def open(project_name)
      Zoho::Project.open(project_name)
    end

  end
end