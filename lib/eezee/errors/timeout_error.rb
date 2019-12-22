# frozen_string_literal: true

module Eezee
  class TimeoutError < Error
    attr_reader :response

    def initialize(response)
      @response = response
      super(response.original)
    end

    def log
      Eezee::Logger.error(self)
    end
  end
end
