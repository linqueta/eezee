# frozen_string_literal: true

module Katinguele
  class NotImplementedError < StandardError
    attr_reader :origin, :method

    def initialize(origin, method)
      @origin = origin
      @method = method
      super(build_message)
    end

    private

    def build_message
      "The method #{@method} is not implemented in #{@origin}"
    end
  end
end
