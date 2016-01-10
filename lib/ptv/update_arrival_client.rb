module Ptv
  class UpdateArrivalClient < BasePtvHttpClient
    def initialize(location, arrival)
      @location = location
      @arrival = arrival
    end

    def call
      request_or_fail_if_response_invalid
    end

    private

    def formatted_arrival
      @formatted_arrival ||= FormattedArrivalForUpdate.new(@arrival, @location).formatted
    end

    def json_payload
      formatted_arrival.merge(default_json_payload)
    end

    def json_response
      @response ||= put('stop/batch', json: json_payload)
    end
  end
end
