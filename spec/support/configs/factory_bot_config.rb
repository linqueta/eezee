# frozen_string_literal: true

require 'factory_bot'

module FactoryBotConfig
  def self.configure(config)
    config.include FactoryBot::Syntax::Methods

    config.before(:suite) do
      FactoryBot.find_definitions
    end
  end
end
