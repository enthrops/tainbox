lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tainbox/version'

Gem::Specification.new do |spec|
  spec.name          = 'tainbox'
  spec.version       = Tainbox::VERSION
  spec.authors       = ['Dmitry Gubitskiy']
  spec.email         = ['d.gubitskiy@gmail.com']

  # TODO Proper summary
  spec.summary       = 'Tainbox summary'
  spec.homepage      = 'https://github.com/enthrops/tainbox'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'activesupport'

  spec.add_development_dependency 'bundler', '~> 1.8'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry'
end
