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
          #{notes}\n}
      puts Zoho::Request.new(endpoint: '/projects/timeentries').post(payload)['message'] unless saved?
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
      @task ||= Zoho::Task.find(project.project_id, attributes[:task])
    end

    def project
      @project ||= Zoho::Project.find(attributes[:project])
    end

    def notes
      if attributes[:notes].present?
        attributes[:notes]
      else
        `git log --pretty=oneline --abbrev-commit --since="#{attributes[:time]} #{attributes[:frequency]} ago"`
      end
    end

    def user
      @user ||= resolve_user
    end

    def users
      @users ||= Zoho::Request.new(endpoint: 'users').get_ostruct(:users)
    end

    def saved?
      @save
    end

    private

    def resolve_begin_time
      amount = attributes[:time]
      frequency = attributes[:frequency]
      amount.to_i.send(frequency).ago
    end

    def resolve_user
      items = users.select { |p| p.name =~ /#{Zoho.config[:user]}/i }
      if items.blank?
        raise ArgumentError.new("No user matched: #{attributes[:user]}\nFound:\n#{users.collect(&:name).join("\n")}")
      elsif items.count > 1
        raise ArgumentError.new("Multiple users matched: #{attributes[:user]}\nFound:\n#{items.collect(&:name).join("\n")}")
      end
      items[0]
    end

  end
end