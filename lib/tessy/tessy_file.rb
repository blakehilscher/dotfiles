module Tessy
  class TessyFile

    ACCEPTABLE_EXTS = ['jpeg', 'jpg', 'png', 'tiff']

    attr_accessor :file_path, :date_format, :date_pattern, :date_data

    def initialize(file_path)
      @file_path = file_path
    end

    def check
      {
          date: date,
          title: title,
          filename: filename,
          file_ext: file_ext,
          date_format: date_format,
          date_pattern: date_pattern,
          date_data: date_data
      }
    end

    def process
      if valid?
        # only rename the file when a date is matched
        # and if the filename is an origianl scan
        rename_file(file_path, semantic_filename) if date.present? && original_filename?
        # always update the contents cache
        write_contents_cache unless contents_cache?
      end
    end

    def valid?
      exists? && ACCEPTABLE_EXTS.include?(file_ext)
    end

    def exists?
      File.exists?(file_path)
    end

    def original_filename?
      filename =~ Tessy::Config.config[:filename][:original]
    end

    def semantic_filename
      [date, title].join(',') + ".#{file_ext}"
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
        FileUtils.mv(original, filename)
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
      log "write_contents_cache #{contents_cache_path}"
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
      string.split("\n").first.to_s.parameterize
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
          /[01]?[0-9]#{sep}[0-3][0-9]#{sep}#{long_year}/ => '%m/%d/%Y',
          /[01]?[0-9]#{sep}[0-3][0-9]#{sep}\d{2}/ => '%m/%d/%y',
          /#{months} \d{1,2}, #{long_year}/i => '%b %d, %Y',
          /#{months} \d{1,2} \d{2}/i => '%b %d %y',
          /\d{1,2}#{sep}#{long_year}/i => '%m/%Y',
          /#{months} \d{1,2}#{sep}\d{2}/i => '%b %d/%y',
          /\d{1,2} #{months} \d{2}/i => '%d %b %y',
          /\d{1,2} #{months} #{sep} \d{2}/i => '%d %b - %y',
          /#{months} \d{1,2},#{long_year}/i => '%b %d,%Y',
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