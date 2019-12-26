# frozen_string_literal: true

module Eezee
  class Configuration
    attr_reader :services

    def initialize
      @services = {}
    end

    def add_service(name, options)
      return unless name && options

      @services[name] = Request.new(options)
    end

    def find_service(name)
      @services[name]
    end

    def request_by(request, options)
      Marshal.dump(request&.attributes || {})
             .then { |dumped| Marshal.load(dumped) } # rubocop:disable Security/MarshalLoad
             .then { |attrs| attrs.merge(options || {}) }
             .then { |attrs| Request.new(attrs) }
    end
  end
end
