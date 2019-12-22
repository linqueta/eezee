# frozen_string_literal: true

require 'eezee/version'
require 'eezee/errors'
require 'eezee/request'
require 'eezee/response'
require 'eezee/request_error_factory'
require 'eezee/logger'
require 'eezee/configuration'
require 'eezee/client'

module Eezee
  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
