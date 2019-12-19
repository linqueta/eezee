# frozen_string_literal: true

require 'json'
require 'faraday'

module Katinguele
  class Response
    attr_reader :original

    def initialize(original)
      @original = original
    end

    def body
      return {} if timeout?

      @body ||= parsed_body
    end

    def success?
      return false if timeout?

      @success ||= faraday_response? && @original&.success?
    end

    def code
      return if timeout?

      @code ||= faraday_response? ? @original.status : @original.response[:status]
    end

    def timeout?
      @original.is_a?(Faraday::TimeoutError) ||
        @original.is_a?(Net::ReadTimeout)    ||
        @original.is_a?(Faraday::ConnectionFailed)
    end

    private

    def parsed_body
      JSON.parse(faraday_response? ? @original.body : @original.response[:body], symbolize_names: true)
    end

    def faraday_response?
      @original.is_a?(Faraday::Response)
    end
  end
end
