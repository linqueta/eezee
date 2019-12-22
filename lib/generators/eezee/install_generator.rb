# frozen_string_literal: true

require 'rails/generators/base'

module Eezee
  class InstallGenerator < Rails::Generators::Base
    def create_initializer_file
      create_file(
        'config/initializers/eezee.rb',
        <<~KATINGUELE_INITIALIZER_TEXT
          # frozen_string_literal: true

          Eezee.configure do |config|
            # You can add your service's configuration, like:

            # config.add_service :external_service_1,
            #                    raise_error: true,
            #                    url: ENV['EXTERNAL_SERVICE_URL_1'],
            #                    headers: { 'Content-Type' => 'application/json' }

            # config.add_service :external_service_2,
            #                    raise_error: false,
            #                    url: ENV['EXTERNAL_SERVICE_URL_2'],
            #                    headers: { 'Token' => "#Token {ENV['EXTERNAL_SERVICE_TOKEN']}"}

            # All available options is on README
          end
        KATINGUELE_INITIALIZER_TEXT
      )
    end
  end
end
