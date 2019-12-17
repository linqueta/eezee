# frozen_string_literal: true

module Katinguele
  class Configuration
    attr_reader :services

    def initialize
      @services = {}
    end

    def add_service(name, options)
      return unless name && options

      @services[name] = Request.new(options)
    end
  end
end
