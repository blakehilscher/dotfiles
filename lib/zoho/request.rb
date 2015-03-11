require 'ostruct'
require 'httparty'

class Zoho
  class Request

    API_HOST = 'https://invoice.zoho.com/api/v3/'

    attr_reader :endpoint, :response_text, :data

    def initialize(options={})
      @endpoint = options[:endpoint]
    end

    def post(payload)
      parse_response http_post_uri(payload)
    end

    def get_ostruct(hash_key)
      get[hash_key.to_s].collect { |r| OpenStruct.new(r) }
    end

    def get
      parse_response http_get_uri
    end

    def http_post_uri(payload)
      url = uri.to_s + '&' + URI.encode_www_form({JSONString: payload.to_json})
      HTTParty.post(url).body
    end

    def http_get_uri
      Net::HTTP.get(uri)
    end

    def uri
      @uri ||= resolve_uri
    end

    def parse_response(response)
      JSON.parse(response)
    rescue => err
      require 'pry'
      binding.pry
    end

    def auth_params
      {
          authtoken: Zoho.config[:authtoken],
          organization_id: Zoho.config[:organization_id]
      }
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