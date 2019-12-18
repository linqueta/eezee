# frozen_string_literal: true

module Katinguele
  class HttpErrorFactory
    class << self
      def build(response)
        find_by_code(response.code).new(response)
      end

      private

      def find_by_code(code)
        case code
        when 400      then BadRequestError
        when 401      then UnauthorizedError
        when 403      then ForbiddenError
        when 404      then ResourceNotFound
        when 422      then UnprocessableEntityError
        when 400..499 then ClientError
        when 500      then InternalServerError
        when 503      then ServiceUnavailableError
        when 500..599 then ServerError
        else
          HttpError
        end
      end
    end
  end
end
