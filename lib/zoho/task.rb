class Zoho
  class Task
    class << self

      def find_or_create(project_id, name)
        task = find(project_id, name)
        if task.blank?
          puts "Task '#{name}' not found, creating ..."
          create(project_id, {task_name: name})
        end
      end

      def find(project_id, name)
        where(project_id, name).first
      end

      def where(project_id, name)
        items = [all(project_id).find { |i| i.task_name == name }].compact
        items = all(project_id).select { |p| p.task_name =~ /#{name}/i } if items.blank?
        items
      end

      # task_name*  string
      # [100] Name of the task
      # description string
      # [500] Project description
      # rate  double  Hourly rate for a task
      # budget_hours  int Task budget hours#
      def create(project_id, attrs)
        response = Zoho::Request.new(endpoint: "/projects/#{project_id}/tasks").post(attrs)
        if response['code'] != 0
          raise ArgumentError.new("Zoho::Task.create #{response['message']}")
        else
          OpenStruct.new(response['task'])
        end
      end

      def all(project_id)
        cache[project_id] ||= Zoho::Request.new(endpoint: "projects/#{project_id}/tasks").get_ostruct(:task)
      end

      def cache
        @cache ||= {}
      end

    end

  end
end