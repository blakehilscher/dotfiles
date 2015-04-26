require 'thor'

require_relative './all.rb'
require_relative './cli/timesheet.rb'

module CLI
  class Base < Thor

    desc "timesheet SUBCOMMAND", "manage timesheets"
    subcommand "timesheet", CLI::Timesheet

    desc "t SUBCOMMAND", "timesheet alias"
    subcommand "t", CLI::Timesheet

  end
end