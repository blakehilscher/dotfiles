module CLI
  class Search < Thor
    namespace 's'

    desc 'music NAME', 'search music'

    def music(*terms)
      url = %Q{https://kat.cr/usearch/#{terms.join(' ')} category:music/?field=seeders&sorder=desc}
      command = %Q{/usr/bin/open -a "/Applications/Google Chrome.app" '#{url}'}
      system(command)
    end

    desc 'music alias', 'search music'
    
    def m(*terms)
      music(*terms)
    end

  end
end