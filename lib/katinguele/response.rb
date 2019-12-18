# frozen_string_literal: true

require 'json'
require 'faraday'

module Katinguele
  class Response
    attr_reader :original

    def initialize(original)
      @original = original
      treat_timeout! if timeout?
    end

    def body
      @body ||= parsed_body
    end

    def success?
      @success ||= faraday_response? && @original&.success?
    end

    def code
      @code ||= faraday_response? ? @original.status : @original.response[:status] unless timeout?
    end

    def timeout?
      @original.is_a?(Faraday::TimeoutError)
    end

    private

    def parsed_body
      JSON.parse(faraday_response? ? @original.body : @original.response[:body], symbolize_names: true)
    end

    def faraday_response?
      @original.is_a?(Faraday::Response)
    end

    def treat_timeout!
      @code = nil
      @body = {}
      @success = false
    end
  end
end
