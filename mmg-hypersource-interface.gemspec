# frozen_string_literal: true
require_relative "lib/mmg/hypersource_interface/version"
Gem::Specification.new do |s|
  s.name        = "mmg-hypersource-interface"
  s.version     = Mmg::HypersourceInterface::VERSION
  s.summary     = "Opaque Rust identity + grammar/SHACL registration -- drop-in peer of mmg-hypersource."
  s.description = "The slot-facing peer of mmg-hypersource: registers the SAME hypersource MCB surface " \
                  "(Mmg::HypersourceInterface, 4 actions) backed by an OPAQUE Rust native extension (native " \
                  "speed, hidden impl). Ships the full grammar-in/graph-out contract -- grammar.bnf + " \
                  "boundary.ttl + SHACL shapes -- so a public consumer needs nothing else. Rust source is a " \
                  "password-protected zip; specs live only in the mmg-hypersource repo. Swap the Gemfile line."
  s.authors     = ["Eric Laquer"]
  s.files       = Dir["lib/**/*", "ext/**/*", "README.md"]
  s.extensions  = ["ext/mmg_hypersource_identity/extconf.rb"]
  s.required_ruby_version = ">= 3.3"
end
