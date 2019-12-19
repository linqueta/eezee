# frozen_string_literal: true

module Katinguele
  class RequestError < Error
    attr_reader :response

    def initialize(response)
      @response = response
      super(build_message)
    end

    def log
      Katinguele::Logger.error(self)
    end

    private

    def build_message
      "CODE: #{@response.code} - BODY: #{@response.body.to_json}"
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
