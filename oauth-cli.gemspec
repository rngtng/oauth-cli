# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name          = "oauth-cli"
  s.version       = "0.0.8"
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["rngtng - Tobias Bielohlawek"]
  s.email         = %q{tobi @nospam@ rngtng.com}
  s.homepage      = %q{http://github.com/rngtng/oauth-cli}
  s.summary       = %q{A simple CLI client to test your oauth API easily}
  s.description   = %q{A simple CLI client to test your oauth API easily}

  s.cert_chain    = ["/Users/tobi/env/keys/gem-public_cert.pem"]
  s.signing_key   = %q{/Users/tobi/env/keys/gem-private_key.pem}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  ["highline >=1.5.1", "json >=1.1.9", "oauth >=0.3.6", "launchy"].each do |gem|
    s.add_dependency *gem.split(' ')
  end

  ["mocha", "bundler"].each do |gem|
    s.add_development_dependency *gem.split(' ')
  end
end