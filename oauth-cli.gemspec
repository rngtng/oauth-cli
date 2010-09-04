# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{oauth-cli}
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["rngtng - Tobias Bielohlawek"]
  s.date = %q{2010-09-04}
  s.default_executable = %q{oauthc}
  s.description = %q{A simple CLI client to test your oauth API easily}
  s.email = %q{tobi @nospam@ rngtng.com}
  s.executables = ["oauthc"]
  s.extra_rdoc_files = ["CHANGELOG", "README.rdoc", "bin/oauthc", "lib/oauth_cli.rb"]
  s.files = ["CHANGELOG", "Manifest", "README.rdoc", "Rakefile", "bin/oauthc", "lib/oauth_cli.rb", "oauth-cli.gemspec", "profiles.yaml", "completion", "test/helper.rb", "test/test_oauth_cli.rb", "test/test_oauthc.rb"]
  s.homepage = %q{http://github.com/rngtng/oauth-cli}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Oauth-cli", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{oauth-cli}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A simple CLI client to test your oauth API easily}
  s.test_files = ["test/test_oauth_cli.rb", "test/test_oauthc.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, [">= 1.5.1"])
      s.add_runtime_dependency(%q<json>, [">= 1.1.9"])
      s.add_runtime_dependency(%q<oauth>, [">= 0.3.6"])
      s.add_runtime_dependency(%q<launchy>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<echoe>, [">= 0"])
    else
      s.add_dependency(%q<highline>, [">= 1.5.1"])
      s.add_dependency(%q<json>, [">= 1.1.9"])
      s.add_dependency(%q<oauth>, [">= 0.3.6"])
      s.add_dependency(%q<launchy>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<echoe>, [">= 0"])
    end
  else
    s.add_dependency(%q<highline>, [">= 1.5.1"])
    s.add_dependency(%q<json>, [">= 1.1.9"])
    s.add_dependency(%q<oauth>, [">= 0.3.6"])
    s.add_dependency(%q<launchy>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<echoe>, [">= 0"])
  end
end
