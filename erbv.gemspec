require_relative "lib/erbv/version"

Gem::Specification.new do |spec|
  spec.name        = "erbv"
  spec.version     = Erbv::VERSION
  spec.authors     = ["Matthew Kennedy"]
  spec.email       = ["m.kennedy@me.com"]
  spec.homepage    = "https://github.com/MatthewKennedy/erbv"
  spec.summary     = "More info about erbv"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/MatthewKennedy/erbv"
  spec.metadata["changelog_uri"] = "https://github.com/MatthewKennedy/erbv/CHANGELG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.3.2"
end
