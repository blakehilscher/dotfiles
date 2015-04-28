module Zoho
  module CLI
    class Base < Thor

      desc "timesheet SUBCOMMAND", "manage timesheets"
      subcommand "timesheet", Zoho::CLI::Timesheet

      desc "t SUBCOMMAND", "timesheet alias"
      subcommand "t", Zoho::CLI::Timesheet

    end
  end
end