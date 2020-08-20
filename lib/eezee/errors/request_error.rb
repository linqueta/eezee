# frozen_string_literal: true

module Eezee
  class RequestError < Error
    attr_reader :response, :request

    def initialize(request = nil, response = nil)
      @request = request
      @response = response
      super(build_message)
    end

    def log
      Eezee::Logger.error(self)
    end

    private

    def build_message
      "CODE: #{@response&.code} - URI: #{@request&.uri} - BODY: #{@response&.body&.to_json}"
    end
  end

  class BadRequestError < RequestError; end
  class UnauthorizedError < RequestError; end
  class ForbiddenError < RequestError; end
  class ResourceNotFoundError < RequestError; end
  class UnprocessableEntityError < RequestError; end
  class ClientError < RequestError; end
  class InternalServerError < RequestError; end
  class ServiceUnavailableError < RequestError; end
  class ServerError < RequestError; end
end
