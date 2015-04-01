# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'honor_codes/version'

Gem::Specification.new do |spec|
  spec.name          = 'honor_codes'
  spec.version       = HonorCodes::VERSION
  spec.authors       = ['Robbie Gill']
  spec.email         = ['gill.rob@gmail.com']
  spec.summary       = %q{Generate honor code style licences}
  spec.homepage      = 'https://github.com/robbiegill/honor_codes'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = %w{honor_codes}
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = %w{lib}

  spec.add_runtime_dependency 'thor', '~> 0.19.1'

  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.0.0.beta1'
end
