lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tainbox/version'

Gem::Specification.new do |spec|
  spec.name          = 'tainbox'
  spec.version       = Tainbox::VERSION
  spec.authors       = ['Dmitry Gubitskiy']
  spec.email         = ['d.gubitskiy@gmail.com']

  spec.summary       = 'Tainbox is a utility gem that can be used to inject attributes '\
                       'into ruby objects. It is similar to Virtus, but works a bit more '\
                       'sensibly (hopefully) and throws in some additional features'
  spec.homepage      = 'https://github.com/enthrops/tainbox'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
end
