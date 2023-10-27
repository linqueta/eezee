# frozen_string_literal: true

require 'oj'
require 'faraday'
require 'forwardable'

module Eezee
  class Response
    attr_reader :original

    extend Forwardable

    def_delegator :body, :[]

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
      Eezee::Logger.response(self)
    end

    private

    def parsed_body
      response = faraday_response
      return {} if response.nil? || response.empty?

      Oj.load(response, symbol_keys: true)
    rescue StandardError
      { response: response }
    end

    def success_response?
      @original.is_a?(Faraday::Response)
    end

    def faraday_response
      success_response? ? @original.body : @original.response[:body]
    end
  end
end
