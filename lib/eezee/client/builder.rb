# frozen_string_literal: true

module Eezee
  module Client
    class UnknownServiceError < StandardError; end

    module Builder
      def self.extended(base)
        base.send(:build_eezee_options)
        base.send(:build_eezee_request_attributes)
        base.eezee_options
      end

      def eezee_request_options(options)
        build_eezee_request_options(options)
      end

      def eezee_service(name, options = {})
        build_eezee_service(name, { lazy: false }.merge(options || {}))
      end

      private

      def build_eezee_options
        define_singleton_method(:eezee_options) { @eezee_options ||= {} }
      end

      def build_eezee_request_options(options = {})
        eezee_options[:request_options] ||= options
        build_eezee_request
      end

      def build_eezee_service(name = nil, options = {})
        eezee_options[:service_name] ||= name
        eezee_options[:service_options] ||= options
        build_eezee_request
      end

      def build_eezee_request(force: false)
        Eezee.configuration
             .find_service(eezee_options[:service_name])
             .then { |service| handle_unknown_service!(service, force) }
             .then { |service| create_request(service, force) }
             .then { |request| eezee_options[:request] = request }
             .then { build_eezee_request_attributes }
      end

      def build_eezee_request_attributes
        define_singleton_method(:eezee_request_attributes) { eezee_options&.[](:request)&.attributes || {} }
      end

      def handle_unknown_service!(service, force)
        return unless take_request?(force)
        raise UnknownServiceError if !service && eezee_options[:service_name]

        service
      end

      def take_request?(force)
        !eezee_options.dig(:service_options, :lazy) || force
      end

      def create_request(service, force)
        return unless take_request?(force)

        Eezee.configuration.request_by(service, eezee_options[:request_options])
      end
    end
  end
end
