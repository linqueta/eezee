# frozen_string_literal: true

module Katinguele
  module Client
    class UnknownService < StandardError; end

    module Builder
      def self.extended(base)
        base.send(:build_katinguele_options)
        base.send(:build_katinguele_request_attributes)
        base.katinguele_options
      end

      def katinguele_request_options(options)
        build_katinguele_request_options(options)
      end

      def katinguele_service(name, options = {})
        build_katinguele_service(name, { lazy: false }.merge(options || {}))
      end

      private

      def build_katinguele_options
        define_singleton_method(:katinguele_options) { @katinguele_options ||= {} }
      end

      def build_katinguele_request_options(options = {})
        katinguele_options[:request_options] ||= options
        build_katinguele_request
      end

      def build_katinguele_service(name = nil, options = {})
        katinguele_options[:service_name] ||= name
        katinguele_options[:service_options] ||= options
        build_katinguele_request
      end

      def build_katinguele_request(force = false)
        Katinguele.configuration
                  .find_service(katinguele_options[:service_name])
                  .then { |service| handle_unknown_service!(service, force) }
                  .then { |service| create_request(service, force) }
                  .then { |request| katinguele_options[:request] = request }
                  .then { build_katinguele_request_attributes }
      end

      def build_katinguele_request_attributes
        define_singleton_method(:katinguele_request_attributes) { katinguele_options&.[](:request)&.attributes || {} }
      end

      def handle_unknown_service!(service, force)
        return unless take_request?(force)
        raise UnknownService if !service && katinguele_options[:service_name]

        service
      end

      def take_request?(force)
        !katinguele_options.dig(:service_options, :lazy) || force
      end

      def create_request(service, force)
        return unless take_request?(force)

        Katinguele.configuration.request_by(service, katinguele_options[:request_options])
      end
    end
  end
end
