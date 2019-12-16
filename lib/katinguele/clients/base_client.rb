# frozen_string_literal: true

module Katinguele
  class BaseClient
    class << self
      def get(_request)
        raise_not_implemented_error(:get)
      end

      def post(_request)
        raise_not_implemented_error(:post)
      end

      def patch(_request)
        raise_not_implemented_error(:patch)
      end

      def put(_request)
        raise_not_implemented_error(:put)
      end

      def delete(_request)
        raise_not_implemented_error(:delete)
      end

      private

      def raise_not_implemented_error(method)
        raise Katinguele::NotImplementedError.new(self, method)
      end
    end
  end
end
