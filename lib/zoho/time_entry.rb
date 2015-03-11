class Zoho
  class TimeEntry

    attr_reader :attributes

    def initialize(attrs={})
      @attributes = attrs
    end

    def save
      puts %Q{
      Creating:
        project: #{project.project_name}
        task: #{task.task_name}
        begin_time: #{begin_time.strftime("%I:%M %p")}
        notes:
          #{notes}\n\n}

      puts Zoho::Request.new(endpoint: '/projects/timeentries').post(payload)['message'] unless saved?
      `open "https://invoice.zoho.com/app#/timesheet/projects/#{project.project_id}"`
    end

    def payload
      {
          project_id: project.project_id,
          task_id: task.task_id,
          log_date: begin_time.strftime('%Y-%m-%d'),
          begin_time: begin_time.strftime('%H:%M'),
          end_time: Time.now.strftime('%H:%M'),
          is_billable: true,
          notes: notes,
          user_id: user.user_id
      }
    end

    def begin_time
      @begin_time ||= resolve_begin_time
    end

    def task
      @task ||= resolve_task
    end

    def project
      @project ||= resolve_project
    end

    def notes
      `git log --pretty=oneline --abbrev-commit --since="#{attributes[:time][0]} #{attributes[:time][1]} ago"`
    end

    def user
      @user ||= resolve_user
    end

    def users
      @users ||= Zoho::Request.new(endpoint: 'users').get_ostruct(:users)
    end

    def projects
      @projects ||= Zoho::Request.new(endpoint: 'projects').get_ostruct(:projects)
    end

    def tasks
      @tasks ||= Zoho::Request.new(endpoint: "/projects/#{project.project_id}/tasks").get_ostruct(:task)
    end

    def saved?
      @save
    end

    private

    def resolve_begin_time
      amount = attributes[:time][0]
      frequency = attributes[:time][1]
      amount.to_i.send(frequency).ago
    end

    def resolve_user
      items = users.select { |p| p.name =~ /#{Zoho.config[:user]}/i }
      if items.blank?
        raise ArgumentError.new("No task matched: #{attributes[:task]}\nFound:\n#{users.collect(&:task_name).join("\n")}")
      elsif items.count > 1
        raise ArgumentError.new("Multiple users matched: #{attributes[:task]}\nFound:\n#{items.collect(&:task_name).join("\n")}")
      end
      items[0]
    end

    def resolve_task
      items = tasks.select { |p| p.task_name =~ /#{attributes[:task]}/i }
      if items.blank?
        raise ArgumentError.new("No task matched: #{attributes[:task]}\nFound:\n#{tasks.collect(&:task_name).join("\n")}")
      elsif items.count > 1
        raise ArgumentError.new("Multiple tasks matched: #{attributes[:task]}\nFound:\n#{items.collect(&:task_name).join("\n")}")
      end
      items[0]
    end

    def resolve_project
      items = projects.select { |p| p.project_name =~ /#{attributes[:project]}/i }
      if items.blank?
        raise ArgumentError.new("No projects matched: #{attributes[:project]}\nFound:\n#{projects.collect(&:project_name).join("\n")}")
      elsif items.count > 1
        raise ArgumentError.new("Multiple projects matched: #{attributes[:project]}\nFound:\n#{items.collect(&:project_name).join("\n")}")
      end
      items[0]
    end

  end
end