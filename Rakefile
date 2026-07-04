# frozen_string_literal: true
# darwin-arm64 ONLY (per operator). Native-extension. `rake compile` builds the local .bundle (needs the
# decrypted Rust source: MMG_RUST_SRC_PASSWORD or the main-repo password file). No cross matrix.
begin
  require "rb_sys/extensiontask"
  RbSys::ExtensionTask.new("mmg_hypersource_identity") do |ext|
    ext.lib_dir = "lib"
    ext.ext_dir = "ext/mmg_hypersource_identity"
  end
rescue LoadError
  warn "[mmg-hypersource-interface] rb_sys not installed -- `gem install rb_sys` to build the native ext."
end
