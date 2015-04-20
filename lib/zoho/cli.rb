require 'thor'

require_relative './all.rb'
require_relative './cli/project.rb'
require_relative './cli/time.rb'

module CLI
  class Base < Thor

    desc "time SUBCOMMAND ...ARGS", "manage time"
    subcommand "time", CLI::Time

    desc "project SUBCOMMAND ...ARGS", "manage time"
    subcommand "project", CLI::Project

  end
end