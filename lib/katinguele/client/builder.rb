# frozen_string_literal: true

module Katinguele
  module Client
    class UnknwonService < StandardError; end

    module Builder
      def self.extended(base)
        base.send(:build_katinguele_options)
        base.send(:build_katinguele_request_attributes)
        base.katinguele_options
      end

      def katinguele_request_options(options)
        build_katinguele_request_options(options)
      end

      def katinguele_service(name)
        build_katinguele_service(name)
      end

      private

      def build_katinguele_options
        define_singleton_method(:katinguele_options) { @katinguele_options ||= {} }
      end

      def build_katinguele_request_options(options = {})
        katinguele_options[:request_options] ||= options
        build_katinguele_request
      end

      def build_katinguele_service(name = nil)
        katinguele_options[:service_name] ||= name
        build_katinguele_request
      end

      def build_katinguele_request
        Katinguele.configuration
                  .find_service(katinguele_options[:service_name])
                  .then { |service| handle_unknown_service!(service) }
                  .then { |service| create_request(service) }
                  .then { |request| katinguele_options[:request] = request }
        build_katinguele_request_attributes
      end

      def build_katinguele_request_attributes
        define_singleton_method(:katinguele_request_attributes) { katinguele_options&.[](:request)&.attributes }
      end

      def handle_unknown_service!(service)
        raise UnknwonService if !service && katinguele_options[:service_name]

        service
      end

      def create_request(service)
        Katinguele.configuration.request_by(service, katinguele_options[:request_options])
      end
    end
  end
end
