module Ptv
  class DeleteLocationClient < BasePtvHttpClient
    def initialize(location)
      @location = location
    end

    def call
      request_or_fail_if_response_invalid
    end

    private

    def query_params
      default_json_payload
    end

    def json_response
      @response ||= delete("location/#{@location.ptv_location_id}", params: query_params)
    end
  end
end
