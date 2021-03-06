module Ptv
  class UpdateLocationClient < BasePtvHttpClient
    def initialize(location)
      @location = location
    end

    def call
      request_or_fail_if_response_invalid
    end

    def ptv_location_id
      response_body['location']['locationId']
    end

    def revision
      response_body['location']['revision']
    end

    private

    def formatted_location
      @formatted_location ||=
        FormattedLocation.new(@location).formatted.merge(locationId: @location.ptv_location_id)
    end

    def json_payload
      default_json_payload.merge({ location: formatted_location })
    end

    def json_response
      @response ||= put('location', json: json_payload)
    end
  end
end
