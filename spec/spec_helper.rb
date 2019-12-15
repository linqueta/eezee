# frozen_string_literal: true

require 'bundler/setup'
require 'support/configs/simple_cov_config'
require 'support/configs/vcr_config'
SimpleCovConfig.configure

require 'katinguele'
require 'pry'
VCRConfig.configure

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
