# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'business_period'

Gem::Specification.new do |spec|
  spec.name          = 'business-period'
  spec.version       = BusinessPeriod::VERSION
  spec.authors       = ['matas']
  spec.email         = ['matas.simonaitis@ksdigital.lt']

  spec.summary       = '📅 calculate business period'
  spec.description   = ''
  spec.homepage      = 'https://github.com/matass/business-period'
  spec.license       = 'MIT'

  spec.platform = Gem::Platform::RUBY

  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.4.1'

  spec.add_development_dependency 'rspec', '~> 3.0'
end
