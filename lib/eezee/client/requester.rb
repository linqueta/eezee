# frozen_string_literal: true

require 'faraday'
require 'json'

module Eezee
  module Client
    module Requester
      METHODS = %i[get post patch put delete].freeze

      def self.extended(base)
        METHODS.each do |method|
          base.send(
            :define_singleton_method,
            method,
            ->(options = {}) { eezee_client_request(options, method) }
          )
        end
      end

      def eezee_client_request(options, method)
        request = build_final_request(options, method)

        build_faraday_client(request)
          .then { |client| build_faraday_request(request, client, method) }
          .then { |response| Eezee::Response.new(response) }
          .tap  { |response| response.log if request.logger }
          .tap  { |response| request.after!(request, response, nil) }
      rescue Faraday::Error => e
        response = Eezee::Response.new(e)
        error = Eezee::RequestErrorFactory.build(response)
        error.log if request.logger
        return response if rescue_faraday_error?(request, response, error)

        raise error
      end

      def build_final_request(options, method)
        build_eezee_request_lazy

        Eezee.configuration
             .request_by(eezee_options[:request], options)
             .tap do |request|
          request.before!(request)
          request.method = method
          request.log if request.logger
        end
      end

      def build_eezee_request_lazy
        return unless eezee_options.dig(:service_options, :lazy)

        build_eezee_request(true)
      end

      def rescue_faraday_error?(req, res, err)
        req.after!(req, res, err) || (err.is_a?(Eezee::TimeoutError) && !req.raise_error)
      end

      def build_faraday_request(req, client, method)
        client.send(method) do |faraday_req|
          faraday_req.body = req.payload.to_json if req.payload
        end
      end

      def build_faraday_client(request)
        Faraday.new(request.uri) do |config|
          config.use(Faraday::Response::RaiseError) if request.raise_error
          config.headers = request.headers if request.headers
          config.options[:open_timeout] = request.open_timeout if request.open_timeout
          config.options[:timeout] = request.timeout if request.timeout
          config.adapter(Faraday.default_adapter)
        end
      end
    end
  end
end
