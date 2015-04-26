class Zoho
  class Config

    attr_reader :config_path

    def initialize(path)
      @config_path = path
    end

    def config
      @config ||= load
    end

    def load
      # load
      config = File.exists?(config_path) ? YAML.load(File.read(config_path)).with_indifferent_access : {}
      # validate
      assert_valid!(config)
    end

    def update(options={})
      data = config.merge(options)
      File.write(config_path, data.to_yaml)
    end

    def assert_valid!(config)
      if config[:authtoken].blank? || config[:organization_id].blank? || config[:user].blank?
        raise ArgumentError.new("\n\nYou must create a zoho auth file:\n#{config_path}\n\nIt must contain:\nauthtoken: xyz\norganization_id: 123\nuser_id: 123\n\n")
      end
      config
    end

  end

end

