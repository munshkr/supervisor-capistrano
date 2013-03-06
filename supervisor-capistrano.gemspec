# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'supervisor/capistrano/version'

Gem::Specification.new do |spec|
  spec.name          = "supervisor-capistrano"
  spec.version       = Supervisor::Capistrano::VERSION
  spec.authors       = ["Damián Silvani"]
  spec.email         = ["munshkr@gmail.com"]
  spec.description   = %q{Supervisor integration for Capistrano}
  spec.summary       = %q{Capistrano recipes for controling a Supervisor instance}
  spec.homepage      = "https://github.com/munshkr/supervisor-capistrano"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
