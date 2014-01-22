# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-webpost"
  spec.version       = "0.0.1"
  spec.authors       = ["ma2saka"]
  spec.email         = [""]
  spec.description   = %q{fluent plugin, post message for target url. }
  spec.summary       = %q{fluent plugin, post message for target url. }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "fluentd"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "rb-inotify"
  spec.add_development_dependency "guard-shell"
  spec.add_development_dependency "guard-rake"
  spec.add_development_dependency "rr"

  spec.add_runtime_dependency "fluentd"
end
