# frozen_string_literal: true

module Katinguele
  module Logger
    module_function

    def request(req, method)
      p log("request: #{method} #{req.uri}")
      p log("request: HEADERS: #{req.headers.to_json}") if req.headers
      p log("request: PAYLOAD: #{req.payload.to_json}") if req.payload
      nil
    end

    # def response(res)
    #   puts log("response: SUCCESS: #{res.success?}")
    #   puts log("response: CODE: #{res.code}")
    #   puts log("response: BODY: #{res.body}")
    # end

    # def error(err)
    #   puts log("error: #{err.class}")
    #   puts log("error: CODE: #{err.code}")
    #   puts log("error: BODY: #{err.body}")
    # end

    def log(message)
      "INFO -- #{message}"
    end
  end
end
