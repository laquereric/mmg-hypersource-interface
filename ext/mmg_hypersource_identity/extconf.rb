# frozen_string_literal: true
require "fileutils"

def skip!(msg)
  warn "[mmg-hypersource-interface] #{msg}; native ext NOT built (actions report :native_unavailable until built)."
  File.write("Makefile", "all:\n\t@true\ninstall:\n\t@true\nclean:\n\t@true\n")
  exit 0
end

here = __dir__
begin
  require "rb_sys/mkmf"
rescue LoadError
  skip!("rb_sys not available")
end

unless File.exist?(File.join(here, "Cargo.toml"))
  pw = ENV["MMG_RUST_SRC_PASSWORD"]
  pw ||= begin
    f = File.expand_path("../../../../../secrets/mmg-hypersource-interface.rust-src.password", here)
    File.exist?(f) ? File.read(f).lines.grep_v(/\A\s*#/).first.to_s.strip : nil
  end
  skip!("encrypted Rust source: no MMG_RUST_SRC_PASSWORD") if pw.to_s.empty?
  system("unzip", "-q", "-o", "-P", pw, File.join(here, "rust_src.zip"), "-d", here) || skip!("unzip failed (wrong password?)")
end

create_rust_makefile("mmg_hypersource_identity")
