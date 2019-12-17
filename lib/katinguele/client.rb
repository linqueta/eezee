# frozen_string_literal: true

require_relative 'client/builder'

module Katinguele
  module Client
    class UnknwonService < StandardError; end

    def self.extended(base)
      base.send(:extend, Builder)
    end
  end
end
