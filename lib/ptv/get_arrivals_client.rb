module Ptv
  class GetArrivalsClient < BasePtvHttpClient
    ITEMS_PER_PAGE = 1

    attr_reader :json_response

    def initialize(location)
      @location = location
      @start_index = 0
      @arrivals = []
    end

    def pages(to_page)
      limit = to_page * ITEMS_PER_PAGE
      loop do
        @json_response = find_arrivals
        response = make_response(@json_response)
        @arrivals.push(response)
        break if (@start_index + ITEMS_PER_PAGE) >= limit
        @start_index += ITEMS_PER_PAGE
      end
      @arrivals.flatten
    end

    def page(page)
      @start_index = ITEMS_PER_PAGE * page
      @json_response = find_arrivals
      make_response(@json_response)
    end

    private

    def additional_params
      {
        from: (Time.now.utc - 1.hour).strftime('%FT%T%:z'),
        until: (Time.now.utc + 26.hours).strftime('%FT%T%:z'),
        sortOrder: 'etaInfo.eta|DESC',
        itemsPerPage: ITEMS_PER_PAGE,
        startIndex: @start_index
      }
    end

    def query_params
      default_json_payload.merge(additional_params)
    end

    def find_arrivals
      get("location/arrivals/#{@location.ptv_location_id}", params: query_params)
    end

    def make_response(response)
      response_checker = Ptv::ResponseChecker.new(response)
      response_checker.call
      if response_checker.success
        response_body['arrivals']
      else
        response_checker.error_response
      end
    end
  end
end
