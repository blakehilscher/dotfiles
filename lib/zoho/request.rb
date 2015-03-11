class Zoho
  class Request

    class << self
      attr_accessor :default_config
    end

    API_HOST = 'https://invoice.zoho.com/api/v3/'

    attr_reader :config, :endpoint, :response_text, :data

    def initialize(options={})
      @config = options[:config] || self.class.default_config
      @endpoint = options[:endpoint]
    end

    def post(payload)
      parse_response http_post_uri(payload)
    end

    def get
      parse_response http_get_uri
    end

    def http_post_uri(payload)
      Net::HTTP.post_form(uri, payload)
    end

    def http_get_uri
      Net::HTTP.get(uri)
    end

    def uri
      @uri ||= resolve_uri
    end

    def parse_response(response)
      JSON.parse(response)
    end

    def auth_params
      {authtoken: authtoken, organization_id: organization_id}
    end

    def authtoken
      config[:authtoken]
    end

    def organization_id
      config[:organization_id]
    end

    private

    def resolve_uri
      authorize_uri(build_uri)
    end

    def build_uri
      URI(File.join(API_HOST, endpoint.to_s))
    end

    def authorize_uri(uri)
      uri.query = URI.encode_www_form(auth_params)
      uri
    end

  end
end