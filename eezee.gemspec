# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'eezee/version'

Gem::Specification.new do |spec|
  spec.name          = 'eezee'
  spec.version       = Eezee::VERSION
  spec.authors       = ['linqueta']
  spec.email         = ['lincolnrodrs@gmail.com']

  spec.summary       = 'The easiest HTTP client for Ruby'
  spec.description   = 'A library to execute HTTP request in an easy way'
  spec.homepage      = 'https://github.com/linqueta/eezee'
  spec.license       = 'MIT'

  spec.files         = Dir['{lib}/**/*', 'CHANGELOG.md', 'MIT-LICENSE', 'README.md']

  spec.add_runtime_dependency 'faraday', '>= 0.17.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'factory_bot', '~> 5.1', '>= 5.1.1'
  spec.add_development_dependency 'pry-byebug', '~> 3.7', '>= 3.7.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.74', '>= 0.74.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.4', '>= 1.4.1'
  spec.add_development_dependency 'simplecov', '~> 0.17', '>= 0.17.0'
  spec.add_development_dependency 'simplecov-console', '~> 0.5', '>= 0.5.0'
  spec.add_development_dependency 'vcr', '~> 5.0', '>= 5.0.0'
  spec.add_development_dependency 'webmock', '~> 3.7', '>= 3.7.6'
end
