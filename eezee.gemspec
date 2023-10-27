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

  spec.required_ruby_version = '>= 2.7'

  spec.add_runtime_dependency 'faraday', '>= 2.7'
  spec.add_runtime_dependency 'faraday-retry'
  spec.add_runtime_dependency 'oj'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
