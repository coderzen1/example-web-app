module Ptv
  class CreateArrivalClient < BasePtvHttpClient
    def initialize(location, arrival)
      @location = location
      @arrival = arrival
    end

    def call
      request_or_fail_if_response_invalid
    end

    def vehicle_scem_id
      response_body['tour']['stops'][0]['scemid']
    end

    private

    def formatted_arrival
      @formatted_arrival ||= FormattedArrivalForCreate.new(@arrival, @location).formatted
    end

    def json_payload
      default_json_payload.merge({ tour: formatted_arrival })
    end

    def json_response
      @response ||= post('tour', json: json_payload)
    end

  end
end
