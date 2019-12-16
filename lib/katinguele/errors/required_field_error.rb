# frozen_string_literal: true

module Katinguele
  class RequiredFieldError < StandardError
    attr_reader :origin, :field

    def initialize(origin, field)
      @origin = origin
      @field = field
      super(build_message)
    end

    private

    def build_message
      "The field #{@field} is required for #{@origin}"
    end
  end
end
