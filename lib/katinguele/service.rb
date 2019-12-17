# frozen_string_literal: true

module Katinguele
  class Service
    ACCESSORS = %i[
      after
      before
      headers
      logger
      params
      path
      payload
      protocol
      raise_error
      url
    ].freeze

    attr_reader :urn
    attr_accessor(*ACCESSORS)

    def initialize(params = {})
      accessors!(params)
      validate!
      build_urn!
      handle_query_params!
      handle_urn_params!
    end

    private

    def validate!
      raise Katinguele::RequiredFieldError.new(self.class, :url) unless @url

      validate_hooks!(:after, @after, %i[service response])
      validate_hooks!(:before, @before, %i[service])
    end

    def validate_hooks!(name, hook, parameters)
      return if !hook&.is_a?(Proc) || hook&.parameters&.length == parameters.length

      raise Katinguele::InvalidValueError.new(
        self.class,
        name,
        <<~SNIPPET
          You should pass #{parameters.length} params in a lambda like:
          ->(#{parameters.join(', ')}) { do_something!(parameters.join(', ') }
        SNIPPET
      )
    end

    def accessors!(params)
      params.slice(*ACCESSORS)
            .each { |k, v| instance_variable_set("@#{k}", v) }
    end

    def build_urn!
      @urn = [@protocol, [@url, @path].compact.join('/')].compact.join('://')
    end

    def handle_urn_params!
      return unless @params.is_a?(Hash)

      @params.filter { |k, _v| @urn.include?(":#{k}") }
             .each   { |k, v|  @urn.gsub!(":#{k}", v.to_s) }
    end

    def handle_query_params!
      return unless @params.is_a?(Hash)

      @params.reject { |k, _v| @urn.include?(":#{k}") }
             .map    { |k, v|  "#{k}=#{v}" }
             .then   { |array| array.join('&') }
             .then   { |query| @urn = [@urn, query].compact.join('?') }
    end
  end
end
