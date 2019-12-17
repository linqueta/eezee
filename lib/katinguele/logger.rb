# frozen_string_literal: true

module Katinguele
  module Logger
    module_function

    def request(service, verb)
      p log("request: #{verb} #{service.urn}")
      p log("request: HEADERS: #{service.headers.to_json}") if service.headers
      p log("request: PAYLOAD: #{service.payload.to_json}") if service.payload
      nil
    end

    # def response(response)
    #   puts log("response: SUCCESS: #{response.success?}")
    #   puts log("response: CODE: #{response.code}")
    #   puts log("response: BODY: #{response.body}")
    # end

    # def error(error)
    #   puts log("error: #{error.class}")
    #   puts log("error: CODE: #{error.code}")
    #   puts log("error: BODY: #{error.body}")
    # end

    def log(message)
      "INFO -- #{message}"
    end
  end
end
