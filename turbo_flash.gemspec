# frozen_string_literal: true

require_relative 'lib/turbo_flash/version'

Gem::Specification.new do |spec|
  spec.name        = 'turbo_flash'
  spec.version     = TurboFlash::VERSION
  spec.authors     = ['barseek']
  spec.email       = ['sergey.b@hey.com']
  spec.homepage    = 'https://github.com/vagab/turbo_flash'
  spec.summary     = 'Automagically include your flash messages in your Ruby on Rails TurboStream responses.'
  spec.description = spec.summary
  spec.license     = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage

  spec.files = Dir['lib/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'turbo-rails', '~> 1.4'
end
