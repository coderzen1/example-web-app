module Ptv
  class ResponseChecker
    attr_reader :success
    attr_reader :error_response
    attr_reader :response_body

    def initialize(response)
      @response_body = JSON.parse(response.body)
      @response_code = response.code
      @error_response = {}
    end

    def call
      check_response_status
    end

    private

    def check_response_status
      if response_success?
        @success = true
      else
        @success = false
        set_error_response
        Bugsnag.notify(@response_body)
      end
    end

    def response_success?
      @response_body['responseStatus']['errorCode'] == 'SUCCESS'
    end

    def set_error_response
      @error_response['error'] = @response_body
    end
  end
end
