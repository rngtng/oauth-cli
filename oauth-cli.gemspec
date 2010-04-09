# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{oauth-cli}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["rngtng - Tobias Bielohlawek"]
  s.cert_chain = ["/Users/tobiasb/.ssh/gem-public_cert.pem"]
  s.date = %q{2010-04-09}
  s.default_executable = %q{oauthc}
  s.description = %q{A simple CLI client to test your oauth API easily}
  s.email = %q{tobi @nospam@ rngtng.com}
  s.executables = ["oauthc"]
  s.extra_rdoc_files = ["CHANGELOG", "README.rdoc", "bin/oauthc", "lib/oauth_cli.rb"]
  s.files = ["CHANGELOG", "Manifest", "README.rdoc", "Rakefile", "bin/oauthc", "init.rb", "lib/oauth_cli.rb", "oauth-cli.gemspec"]
  s.homepage = %q{http://github.com/rngtng/oauth-cli}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Oauth-cli", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{oauth-cli}
  s.rubygems_version = %q{1.3.6}
  s.signing_key = %q{/Users/tobiasb/.ssh/gem-private_key.pem}
  s.summary = %q{A simple CLI client to test your oauth API easily}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<highline>, [">= 1.5.1"])
      s.add_runtime_dependency(%q<json>, [">= 1.1.9"])
      s.add_runtime_dependency(%q<oauth>, [">= 0.3.6"])
      s.add_runtime_dependency(%q<repl>, [">= 0.2.1"])
    else
      s.add_dependency(%q<highline>, [">= 1.5.1"])
      s.add_dependency(%q<json>, [">= 1.1.9"])
      s.add_dependency(%q<oauth>, [">= 0.3.6"])
      s.add_dependency(%q<repl>, [">= 0.2.1"])
    end
  else
    s.add_dependency(%q<highline>, [">= 1.5.1"])
    s.add_dependency(%q<json>, [">= 1.1.9"])
    s.add_dependency(%q<oauth>, [">= 0.3.6"])
    s.add_dependency(%q<repl>, [">= 0.2.1"])
  end
end
