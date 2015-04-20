module Tessy
  class TessyFile

    ACCEPTABLE_EXTS = ['jpeg', 'jpg', 'png', 'tiff']

    attr_accessor :file_path, :date_format, :date_pattern, :date_data, :options

    def initialize(file_path, options={})
      @file_path = file_path
      @options = options
    end

    def check
      if valid?
        write_contents_cache
        {
            date: date,
            title: title,
            semantic_filename: semantic_filename,
            tags: resolve_tags,
            filename: filename,
            file_ext: file_ext,
            date_format: date_format,
            date_pattern: date_pattern,
            date_data: date_data
        }
      else
        {}
      end
    end

    def process
      if valid?
        log(filename) if options[:verbose]
        # always update the contents cache
        write_contents_cache unless contents_cache?
        # only rename the file when a date is matched
        # and if the filename is an origianl scan
        rename_file(file_path, semantic_filename) if date.present? && original_filename?
      end
    end

    def valid?
      exists? && ACCEPTABLE_EXTS.include?(file_ext)
    end

    def exists?
      File.exists?(file_path)
    end

    def original_filename?
      filename =~ Tessy::Config.config[:filename][:original] || options[:force]
    end

    def semantic_filename
      titles = [date] + resolve_tags + [title]
      titles.compact.reject(&:blank?).join(',') + ".#{file_ext}"
    end

    def contents
      @contents ||= resolve_contents
    end

    def date
      @date ||= resolve_date
    end

    def title
      @title ||= resolve_title
    end

    def filename
      @filename ||= File.basename(file_path)
    end

    def file_ext
      @file_ext ||= filename.split('.').last
    end

    private

    def rename_file(original, filename)
      unless original == filename
        log "rename_file #{original} #{filename}"
        unless options[:dry]
          if File.exists?(filename)
            log "#{filename} already exists"
          else
            FileUtils.mv(original, filename)
            FileUtils.mv("#{original}.txt", "#{filename}.txt") if File.exists?("#{original}.txt")
          end
        end
      end
    end

    def resolve_contents
      if contents_cache?
        File.read(contents_cache_path)
      else
        t1 = Time.now
        result = bash %Q{tesseract "#{file_path}" stdout}
        elapsed = ((Time.now - t1) * 1000).to_i
        log "tesseract #{elapsed}ms #{file_path}"
        result
      end
    end

    def write_contents_cache
      log "write_contents_cache #{contents_cache_path}" if options[:verbose]
      File.write(contents_cache_path, contents)
    end

    def contents_cache?
      File.exists?(contents_cache_path)
    end

    def contents_cache_path
      "#{file_path}.txt"
    end

    def resolve_title
      string = reject_patterns(contents, Tessy::Config.config[:title][:reject])
      output = string.split("\n").first.to_s.parameterize
      string.split("\n").find do |line|
        Tessy::Config.config[:title][:accept].find do |pattern, title|
          output = title if line =~ pattern
        end
      end
      page = nil
      string.split("\n").each do |line|
        Tessy::Config.config[:title][:page].each do |pattern|
          match = line.match(pattern)
          page = match[1] if match
        end
      end
      output = "#{output}-#{page}" if page.present?
      output
    end

    def resolve_tags
      tags = []
      contents.split("\n").each do |line|
        Tessy::Config.config[:title][:tags].each do |pattern, tag|
          tags << tag if line =~ pattern && !tags.include?(tag)
        end
      end
      tags.sort
    end

    def resolve_date
      config = Tessy::Config.config[:date]
      # patterns pieces
      string = reject_patterns(contents, config[:reject])
      long_months = config[:long_months]
      short_months = config[:short_months]
      sep = config[:seperator]
      long_year = config[:long_year]
      months = "(#{long_months}|#{short_months})"
      # recognized date formats
      formats = {
          /#{months} \d{1,2}, #{long_year}/i => '%b %d, %Y',
          /#{months} \d{1,2} \d{4}/i => '%b %d %Y',
          /#{months} \d{1,2} \d{2}/i => '%b %d %y',
          /#{months} \d{1,2}#{sep}\d{2}/i => '%b %d/%y',
          /\d{1,2} #{months} \d{4}/i => '%d %b %Y',
          /\d{1,2} #{months} \d{2}/i => '%d %b %y',
          /\d{1,2} #{months} #{sep} \d{2}/i => '%d %b - %y',
          /#{months} \d{1,2},#{long_year}/i => '%b %d,%Y',
          /[0-9]{4}#{sep}[0-9]{2}#{sep}[0-9]{2}/ => '%Y/%m/%d',
          /[01]?[0-9]#{sep}[0-3][0-9]#{sep}#{long_year}/ => '%m/%d/%Y',
          /[01]?[0-9]#{sep}[0-3][0-9]#{sep}\d{2}/ => '%m/%d/%y',
          /\d{1,2}#{sep}#{long_year}/i => '%m/%Y',
      }
      formats.each do |pattern, format|
        data = string.match(pattern)
        if data
          self.date_pattern = pattern
          self.date_format = format
          self.date_data = data
          begin
            return Date.strptime(data[0], format)
          rescue
            return Chronic.parse(data[0]).try(:to_date)
          end
        end
      end
      false
    end

    def reject_patterns(string, patterns)
      string.split("\n").reject(&:blank?).reject do |l|
        patterns.collect { |p| l.match(p) }.join.present?
      end.join("\n")
    end

    def bash(cmd)
      `#{cmd}`.strip
    end

    def log(m)
      puts(m)
    end

  end
end