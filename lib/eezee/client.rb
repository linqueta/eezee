# frozen_string_literal: true

require_relative 'client/builder'
require_relative 'client/requester'

module Eezee
  module Client
    def self.extended(base)
      base.send(:extend, Builder)
      base.send(:extend, Requester)
    end
  end
end
