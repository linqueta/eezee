# frozen_string_literal: true

require 'bundler/setup'
require 'support/configs/simple_cov_config'
require 'support/configs/vcr_config'
require 'support/configs/factory_bot_config'
require 'support/shared/katinguele/client/builder'
require 'pry'

SimpleCovConfig.configure
VCRConfig.configure

require 'katinguele'

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  FactoryBotConfig.configure(config)
end
