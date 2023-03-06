source ENV['GEM_SOURCE'] || 'https://rubygems.org'

group :test do
  gem 'facter', ENV['FACTER_GEM_VERSION'], require: false
  gem 'puppet', ENV.fetch('PUPPET_GEM_VERSION', '>= 6.0'), require: false
  gem 'puppet_metadata', '~> 2.0', require: false
  gem 'voxpupuli-test', '~> 5.4', require: false
end

group :system_tests do
  gem 'voxpupuli-acceptance', '~> 1.0', require: false
end

group :release do
  gem 'voxpupuli-release', '>= 1.2.0', require: false
  gem 'puppet-strings', '>= 2.2', require: false
end

gem 'rake', :require => false

# vim: syntax=ruby
