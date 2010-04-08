# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{oauthc}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["rngtng - Tobias Bielohlawek"]
  s.date = %q{2010-04-08}
  s.description = %q{A simple oauth client to test your oauth connection}
  s.email = %q{tobi @nospam@ rngtng.com}
  s.extra_rdoc_files = ["lib/oauthc.rb"]
  s.files = ["Rakefile", "lib/oauthc.rb", "Manifest", "oauthc.gemspec"]
  s.homepage = %q{http://github.com/rngtng/oauthc}
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Oauthc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{oauthc}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{A simple oauth client to test your oauth connection}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
