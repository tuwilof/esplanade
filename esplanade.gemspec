lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'esplanade/version'

Gem::Specification.new do |spec|
  spec.name           = 'esplanade'
  spec.version        = Esplanade::VERSION
  spec.authors        = ['d.efimov']
  spec.email          = ['d.efimov@fun-box.ru']

  spec.summary        = 'Validate requests and responses against API Blueprint specifications'
  spec.license        = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'json-schema', '~> 2.6', '>= 2.6.2'
  spec.add_runtime_dependency 'multi_json', '~> 1.11', '>= 1.11.1'
  spec.add_runtime_dependency 'tomograph', '~> 2.0', '>= 2.0.0'
  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'byebug', '~> 8.2', '>= 8.2.1'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4', '>= 3.4.0'
  spec.add_development_dependency 'rubocop', '~> 0.52', '>= 0.52.1'
  spec.add_development_dependency 'simplecov', '~> 0.11', '>= 0.11.2'
end
