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

      @success ||= success_response? && @original&.success?
    end

    def code
      return if timeout?

      @code ||= success_response? ? @original.status : @original.response[:status]
    end

    def timeout?
      @original.is_a?(Faraday::TimeoutError) ||
        @original.is_a?(Net::ReadTimeout)    ||
        @original.is_a?(Faraday::ConnectionFailed)
    end

    def log
      Katinguele::Logger.response(self)
    end

    private

    def parsed_body
      JSON.parse(handled_faraday_response, symbolize_names: true)
    end

    def success_response?
      @original.is_a?(Faraday::Response)
    end

    def handled_faraday_response
      faraday_response.nil? || faraday_response.empty? ? '{}' : faraday_response
    end

    def faraday_response
      success_response? ? @original.body : @original.response[:body]
    end
  end
end
