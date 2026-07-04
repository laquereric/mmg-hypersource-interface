# frozen_string_literal: true
require_relative "lib/mmg/hypersource/interface/version"
Gem::Specification.new do |s|
  s.name        = "mmg-hypersource-interface"
  s.version     = Mmg::Hypersource::Interface::VERSION
  s.summary     = "Grammar registration + Rust IDENTITY binary (native ext) -- the matured peer of mmg-hypersource."
  s.description = "The slot-facing matured form of mmg-hypersource: registers the hypersource grammar and " \
                  "backs the deterministic identity with a Rust native extension (byte parity with the Ruby " \
                  "peer, enforced by mmg-hypersource's bench). Rust source ships as a password-protected zip " \
                  "(IP protection); extconf extracts + compiles on install. Native-extension, darwin-arm64."
  s.authors     = ["Eric Laquer"]
  s.platform    = "arm64-darwin"          # precompiled target (only). Source install still needs the zip password.
  s.files       = Dir["lib/**/*", "ext/**/*", "README.md"]
  s.extensions  = ["ext/mmg_hypersource_identity/extconf.rb"]
  s.required_ruby_version = ">= 3.3"
  s.add_dependency "rb_sys"
end
