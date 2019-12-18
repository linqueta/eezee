# frozen_string_literal: true

module Katinguele
  class TimeoutError < Error
    attr_reader :response

    def initialize(response)
      @response = response
      super(response.original)
    end
  end
end
