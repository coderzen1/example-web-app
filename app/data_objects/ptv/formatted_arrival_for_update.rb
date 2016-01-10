module Ptv
  class FormattedArrivalForUpdate
    def initialize(arrival, location)
      @arrival = arrival
      @location = location
    end

    def formatted
      {
        stops: [
          stop
        ]
      }
    end

    private

    def stop
      {
        coordinate: coordinates,
        earliestArrivalTime: @arrival.pta,
        latestDepartureTime: @arrival.pta,
        serviceTimeAtStop: 0,
        useServicePeriodForRecreation: true,
        weightWhenLeavingStop: 0,
        customData: @arrival.custom_fields,
        scemid: @arrival.scemid
      }
    end

    def coordinates
      {
        locationX: @location.longitude,
        locationY: @location.latitude
      }
    end
  end
end
