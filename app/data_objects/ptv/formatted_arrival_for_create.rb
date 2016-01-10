module Ptv
  class FormattedArrivalForCreate
    def initialize(arrival, location)
      @arrival = arrival
      @location = location
    end

    def formatted
      {
        stops: [
          {
            coordinate: {
              locationX: @location.longitude,
              locationY: @location.latitude
            },
            locationId: @location.ptv_location_id,
            earliestArrivalTime: @arrival.pta,
            latestDepartureTime: @arrival.pta,
            customData: @arrival.custom_fields
          }
        ],
        vehicle: {
            vehicleProfileID: Arrival.vehicle_types.key(@arrival.vehicle_type)
        }
      }
    end
  end
end
