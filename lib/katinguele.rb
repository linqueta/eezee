# frozen_string_literal: true

require 'katinguele/version'
require 'katinguele/errors'
require 'katinguele/request'
require 'katinguele/logger'
require 'katinguele/configuration'
require 'katinguele/client'

module Katinguele
  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
