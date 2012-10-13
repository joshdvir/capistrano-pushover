# -*- encoding: utf-8 -*-
require File.expand_path('../lib/capistrano-pushover/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Shuky Dvir"]
  gem.email         = ["shuky@tooveo.com"]
  gem.description   = %q{Send deploy notification to Pushover}
  gem.summary       = %q{Send deploy notification to Pushover}
  gem.homepage      = "https://github.com/shukydvir/capistrano-pushover"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "capistrano-pushover"
  gem.require_paths = ["lib"]
  gem.version       = Capistrano::Pushover::VERSION

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 2.5'
  gem.add_development_dependency 'capistrano-spec', '~> 0.1.0'
  gem.add_development_dependency 'capistrano', '~> 2.0'
  gem.add_dependency 'rushover', '~> 0.1.1'
end
