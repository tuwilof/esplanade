lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'esplanade/version'

Gem::Specification.new do |spec|
  spec.name           = 'esplanade'
  spec.version        = Esplanade::VERSION
  spec.authors        = ['tuwilof']
  spec.email          = ['tuwilof@gmail.com']

  spec.summary        = 'Validate requests and responses against API Blueprint specifications'
  spec.license        = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'json-schema', '~> 2.6', '>= 2.6.2'
  spec.add_runtime_dependency 'tomograph', '~> 3.1', '>= 3.1.0'
  spec.add_development_dependency 'byebug', '~> 11.1', '>= 11.1.3'
  spec.add_development_dependency 'rake', '~> 13.0', '>= 13.0.6'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop', '~> 1.22.0'
  spec.add_development_dependency 'simplecov', '~> 0.21'
  spec.required_ruby_version = '>= 2.4.0'
end
