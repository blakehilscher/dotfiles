module CLI
  class Base < Thor

    desc "search SUBCOMMAND", "search"
    subcommand "search", CLI::Search

    desc "s SUBCOMMAND", "search alias"
    subcommand "s", CLI::Search

  end
end