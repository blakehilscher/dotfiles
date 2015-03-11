class Zoho
  class Task
    class << self

      def find(project_id, name)
        items = where(project_id, name)
        if items.count > 1
          raise ArgumentError.new("Multiple tasks matched: #{name}\nFound:\n#{items.collect(&:task_name).join("\n")}")
        end
        items[0]
      end

      def where(project_id, name)
        items = all(project_id).select { |p| p.task_name =~ /#{name}/i }
        if items.blank?
          raise ArgumentError.new("No tasks matched: #{name}\nFound:\n#{all(project_id).collect(&:task_name).join("\n")}")
        end
        items
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