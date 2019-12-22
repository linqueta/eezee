# frozen_string_literal: true

module Eezee
  module Logger
    module_function

    def request(req, method)
      p log("request: #{method} #{req.uri}")
      p log("request: HEADERS: #{req.headers&.to_json}") if req.headers
      p log("request: PAYLOAD: #{req.payload&.to_json}") if req.payload
      nil
    end

    def response(res)
      p log("response: SUCCESS: #{res.success?}")
      p log("response: TIMEOUT: #{res.timeout?}")
      p log("response: CODE: #{res.code}")
      p log("response: BODY: #{res.body&.to_json}")
    end

    def error(err)
      p log("error: #{err.class}")
      p log("error: SUCCESS: #{err.response.success?}")
      p log("error: TIMEOUT: #{err.response.timeout?}")
      p log("error: CODE: #{err.response.code}")
      p log("error: BODY: #{err.response.body&.to_json}")
    end

    def log(message)
      "INFO -- #{message}"
    end
  end
end
