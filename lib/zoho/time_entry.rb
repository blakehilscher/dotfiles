class Zoho
  class TimeEntry

    class << self
      # POST  /projects/timeentries/timer/stop
      def stop_timer(options={})
        # stop the timer
        response = Zoho::Request.new(endpoint: '/projects/timeentries/timer/stop').post({})
        puts response['message']
        if response['code'] == 0
          # update it with the commits that occurred since the timer started
          entry = OpenStruct.new(response['time_entry'])
          hour, minute = entry.log_time.split(':').collect(&:to_i)
          id = entry.time_entry_id
          notes = options[:notes] || Zoho.bash(%Q{git log --pretty=oneline --abbrev-commit --since="#{hour} hours #{minute} minutes ago"})
          if notes.present?
            update = Zoho::Request.new(endpoint: "/projects/timeentries/#{id}").put({notes: notes})
            puts update['message']
            puts notes
          end
        end
      end
    end

    attr_reader :attributes

    def initialize(attrs={})
      @attributes = attrs
    end

    def save
      data = payload
      puts %Q{
      Creating Timesheet Entry:
        project: #{project.project_name}
        task: #{task.task_name}
        begin_time: #{begin_time.strftime("%I:%M %p")}\n\n}
      puts data[:notes] + "\n\n" if data[:notes].present?
      puts Zoho::Request.new(endpoint: '/projects/timeentries').post(data)['message'] unless saved?
    end

    def payload
      data = {
          project_id: project.project_id,
          task_id: task.task_id,
          log_date: begin_time.strftime('%Y-%m-%d'),
          is_billable: true,
          notes: notes,
          user_id: user.user_id
      }
      if attributes[:start_timer].present?
        data[:start_timer] = true
      else
        data[:begin_time] = begin_time.strftime('%H:%M')
        data[:end_time] = Time.now.strftime('%H:%M')
      end
      data
    end

    def begin_time
      @begin_time ||= resolve_begin_time
    end

    def task
      @task ||= Zoho::Task.find_or_create(project.project_id, attributes[:task])
    end

    def project
      @project ||= Zoho::Project.find(attributes[:project])
    end

    def notes
      if attributes[:notes].present?
        attributes[:notes]
      elsif attributes[:begin_time].present?
        Zoho.bash(%Q{git log --pretty=oneline --abbrev-commit --since="#{begin_time_amount} #{begin_time_frequency} ago"})
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

    def begin_time_amount
      attributes[:begin_time].split('.')[0]
    end

    def begin_time_frequency
      attributes[:begin_time].split('.')[1]
    end

    private

    def resolve_begin_time
      if attributes[:begin_time].present?
        amount, frequency, starting = attributes[:begin_time].split('.')
        if amount.blank? || frequency.blank? || starting.blank?
          raise ArgumentError.new("\n\nbegin_time must be formatted like:\n   amount.frequency.starting\neg:\n   60.minutes.ago\n\n")
        end
        amount.to_i.send(frequency).send(starting)
      else
        1.minute.ago
      end
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