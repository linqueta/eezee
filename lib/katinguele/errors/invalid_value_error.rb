# frozen_string_literal: true

module Katinguele
  class InvalidValueError < StandardError
    attr_reader :origin, :field, :snippet

    def initialize(origin, field, snippet)
      @origin = origin
      @field = field
      @snippet = snippet
      super(build_message)
    end

    private

    def build_message
      ["The field #{@origin}'s #{@field} receives an invalid value", @snippet].compact.join('. ')
    end
  end
end
