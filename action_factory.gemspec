require_relative "lib/action_factory/version"

Gem::Specification.new do |spec|
  spec.name        = "action_factory"
  spec.version     = ActionFactory::VERSION
  spec.authors     = ["Ben Loyola"]
  spec.email       = ["berna.loyola@gmail.com"]
  spec.homepage    = "https://github.com/b-loyola/action_factory"
  spec.summary     = "A Simple OOO Factory lib for Ruby (and Rails)"
  spec.description = "Your factories are now classes."

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://github.com/b-loyola/action_factory"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/b-loyola/action_factory"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "activesupport", ">= 7.0.6"
  spec.add_dependency "activemodel", ">= 7.0.6"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "debug"

  spec.test_files = Dir["spec/**/*"]
end
