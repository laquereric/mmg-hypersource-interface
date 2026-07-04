# frozen_string_literal: true
# Compile-on-install: the Rust source ships as a PASSWORD-PROTECTED zip (rust_src.zip). Extract it with the
# password (MMG_RUST_SRC_PASSWORD env, or the plaintext file in the main repo for now), then build the native
# extension via rb_sys. Precompiled arm64-darwin gems skip this. No password => no source => no Rust peer
# (the Ruby peer in mmg-hypersource still works).
require "fileutils"

here = __dir__
unless File.exist?(File.join(here, "Cargo.toml"))
  pw = ENV["MMG_RUST_SRC_PASSWORD"]
  pw ||= begin
    f = File.expand_path("../../../../../secrets/mmg-hypersource-interface.rust-src.password", here)
    File.exist?(f) ? File.read(f).lines.grep_v(/\A\s*#/).first.to_s.strip : nil
  end
  abort("[mmg-hypersource-interface] Rust source is encrypted; set MMG_RUST_SRC_PASSWORD to build from source") if pw.to_s.empty?
  system("unzip", "-q", "-o", "-P", pw, File.join(here, "rust_src.zip"), "-d", here) or abort("[mmg-hypersource-interface] unzip failed (wrong password?)")
end

require "mkmf"
require "rb_sys/mkmf"
create_rust_makefile("mmg_hypersource_identity")
