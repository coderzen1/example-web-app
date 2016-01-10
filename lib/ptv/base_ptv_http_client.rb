require 'http'

module Ptv
  class BasePtvHttpClient

    BASE_URL = Settings.ptv.base_uri
    TOKEN = Rails.application.secrets.ptv_api_key

    private

    def response_body
      JSON.parse(json_response.body.to_s)
    end

    def default_json_payload
      { token: TOKEN,
        source: 'ptv_arrival_app'
       }
    end

    def http_client
      HTTP
    end

    def get(path, params)
      http_client.headers(accept: 'application/json').get("#{BASE_URL}/#{path}", params)
    end

    def post(path, params)
      http_client.headers(accept: 'application/json').post("#{BASE_URL}/#{path}", params)
    end

    def put(path, params)
      http_client.headers(accept: 'application/json').put("#{BASE_URL}/#{path}", params)
    end

    def delete(path, params)
      http_client.headers(accept: 'application/json').delete("#{BASE_URL}/#{path}", params)
    end

    def request_or_fail_if_response_invalid
      response_checker = Ptv::ResponseChecker.new(json_response)
      response_checker.call
      response_checker
    end
  end
end
