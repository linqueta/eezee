# frozen_string_literal: true

module Katinguele
  class HttpError < Error
    attr_reader :response

    def initialize(response)
      @response = response
      super(build_message)
    end

    private

    def build_message
      "CODE: #{@response.code} - BODY: #{@response.body.to_json}"
    end
  end

  class BadRequestError          < HttpError; end
  class UnauthorizedError        < HttpError; end
  class ForbiddenError           < HttpError; end
  class ResourceNotFound         < HttpError; end
  class UnprocessableEntityError < HttpError; end
  class ClientError              < HttpError; end
  class InternalServerError      < HttpError; end
  class ServiceUnavailableError  < HttpError; end
  class ServerError              < HttpError; end
end
