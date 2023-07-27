require_relative "lib/action_factory/version"

Gem::Specification.new do |spec|
  spec.name        = "action_factory"
  spec.version     = ActionFactory::VERSION
  spec.authors     = ["Ben Loyola"]
  spec.email       = ["berna.loyola@gmail.com"]
  spec.homepage    = "https://github.com/b-loyola/action_factory"
  spec.summary     = "A Simple OOO Factory lib for Ruby (and Rails)"
  spec.description = "Your factories are now classes."

  spec.required_ruby_version = ">= 3.2.2"

  spec.license = "MIT"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/b-loyola/action_factory"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_runtime_dependency 'activesupport', '~> 7.0', '>= 7.0.6'
  spec.add_runtime_dependency 'activemodel', '~> 7.0', '>= 7.0.6'
  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'debug', '~> 1.8'

  spec.test_files = Dir["spec/**/*"]
end
