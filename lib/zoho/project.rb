module Zoho
  class Project
    class << self

      def config
        @config ||= load_config
      end

      def open(project_name)
        project = Zoho::Project.find(project_name)
        Zoho.bash(%Q{open "https://invoice.zoho.com/app#/timesheet/projects/#{project.project_id}"})
      end

      def find(name)
        items = where(name)
        if items.count > 1
          raise ArgumentError.new("Multiple projects matched: #{name}\nFound:\n#{items.collect(&:project_name).join("\n")}")
        end
        items[0]
      end

      def where(name)
        items = [all.find { |p| p.project_name == name }].compact
        items = all.select { |p| p.project_name =~ /#{name}/i } if items.blank?
        if items.blank?
          raise ArgumentError.new("No projects matched: #{name}\nFound:\n#{all.collect(&:project_name).join("\n")}")
        end
        items
      end

      def all
        @all ||= Zoho::Request.new(endpoint: 'projects').get_ostruct(:projects)
      end

      private

      def load_config
        file = upsearch('.zoho')
        if file
          YAML.load(File.read(file)).symbolize_keys
        else
          {}
        end
      end

      def upsearch(filename, path='./')
        search_file = File.expand_path(File.join(path, filename))
        if File.exist?(search_file)
          search_file
        elsif File.expand_path(path) == '/'
          false
        else
          upsearch(filename, File.join(path, '../'))
        end
      end

    end

  end
end