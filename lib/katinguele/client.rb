# frozen_string_literal: true

module Katinguele
  module Client
    def katinguele_request_options(options)
      define_singleton_method(:katinguele_request_options) do
        @katinguele_request_options ||= options
      end
    end
  end
end
