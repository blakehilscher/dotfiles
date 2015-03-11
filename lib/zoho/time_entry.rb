class Zoho
  class TimeEntry


    def initialize(options={})
      puts options
    end

    def save
      Zoho::Request.new(endpoint: '/projects/timeentries').post(payload) unless saved?
    end

    def payload

    end

    def saved?
      @save
    end

  end
end