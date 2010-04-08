# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{oauthc}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["rngtng - Tobias Bielohlawek"]
  s.date = %q{2010-04-08}
  s.default_executable = %q{oauthc}
  s.description = %q{A simple oauth client to test your oauth connection}
  s.email = %q{tobi @nospam@ rngtng.com}
  s.executables = ["oauthc"]
  s.extra_rdoc_files = ["CHANGELOG", "README.rdoc", "bin/oauthc", "lib/oauthc.rb"]
  s.files = ["CHANGELOG", "Manifest", "README.rdoc", "Rakefile", "bin/oauthc", "init.rb", "lib/oauthc.rb", "oauthc.gemspec"]
  s.homepage = %q{http://github.com/rngtng/oauthc}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Oauthc", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{oauthc}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A simple oauth client to test your oauth connection}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, [">= 0", "= 1.5.1"])
      s.add_runtime_dependency(%q<json>, [">= 0", "= 1.1.9"])
      s.add_runtime_dependency(%q<oauth>, [">= 0", "= 0.3.6"])
    else
      s.add_dependency(%q<highline>, [">= 0", "= 1.5.1"])
      s.add_dependency(%q<json>, [">= 0", "= 1.1.9"])
      s.add_dependency(%q<oauth>, [">= 0", "= 0.3.6"])
    end
  else
    s.add_dependency(%q<highline>, [">= 0", "= 1.5.1"])
    s.add_dependency(%q<json>, [">= 0", "= 1.1.9"])
    s.add_dependency(%q<oauth>, [">= 0", "= 0.3.6"])
  end
end
