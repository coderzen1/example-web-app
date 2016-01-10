module Ptv
  class FormattedLocation
    def initialize(location)
      @location = location
    end

    def formatted
      {
        name: @location.name,
        coordinate: {
          locationX: @location.longitude,
          locationY: @location.latitude
        },
        address: address,
        customDataFieldsForStop: custom_fields
      }
    end

    def custom_fields
      if @location.custom_fields.present?
        @location.custom_fields.map { |field| { name: field } }
      else
        []
      end
    end

    def address
      {
        postCode: @location.address.zip_code,
        city: @location.address.city,
        street: @location.address.street,
        houseNumber: @location.address.number
      }
    end
  end
end
