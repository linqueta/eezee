# frozen_string_literal: true

module Katinguele
  class Request
    ACCESSORS = %i[
      after
      before
      headers
      logger
      open_timeout
      params
      path
      payload
      protocol
      raise_error
      timeout
      url
    ].freeze

    attr_accessor(*(ACCESSORS | %i[uri method]))

    def initialize(options = {})
      setup!(options)
    end

    def log
      Katinguele::Logger.request(self, @method.to_s.upcase)
    end

    def setup!(options = {})
      accessors!(options || {})
      validate!
      build_urn!
      handle_query_params!
      handle_urn_params!
    end

    def before!(*params)
      hook!(:before, params)
    end

    def after!(*params)
      hook!(:after, params)
    end

    private

    def hook!(hook, params)
      return unless send(hook)&.is_a?(Proc)

      send(hook).call(*params[0..(send(hook).parameters.length - 1)])
    end

    def validate!
      raise Katinguele::RequiredFieldError.new(self.class, :url) unless @url
    end

    def accessors!(params)
      params.slice(*ACCESSORS)
            .each { |k, v| instance_variable_set("@#{k}", v) }
    end

    def build_urn!
      @uri = [@protocol, [@url, @path].compact.join('/')].compact.join('://')
    end

    def handle_urn_params!
      return unless @params.is_a?(Hash)

      @params.filter { |k, _v| @uri.include?(":#{k}") }
             .each   { |k, v|  @uri.gsub!(":#{k}", v.to_s) }
             .then   { @uri.gsub!(/:[a-z_-]+/, '') }
    end

    def handle_query_params!
      return unless @params.is_a?(Hash)

      @params.reject { |k, _v| @uri.include?(":#{k}") }
             .map    { |k, v|  "#{k}=#{v}" }
             .then   { |array| array.join('&') }
             .then   { |query| query unless query.empty? }
             .then   { |query| @uri = [@uri, query].compact.join('?') }
    end
  end
end
