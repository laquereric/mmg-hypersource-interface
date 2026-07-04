# mmg-hypersource-interface

The matured, slot-facing peer of `mmg-hypersource`: **grammar registration + a Rust IDENTITY native
extension**. Deterministic identity (`arc/<id>/<engine>/<tuning>`) runs in Rust (byte parity with the Ruby
peer, enforced by `mmg-hypersource/spec/identity_parity_bench.rb`). Orchestration stays in `mmg-hypersource`.

- **native-extension** (magnus + rb_sys), in-process.
- **darwin-arm64** only (precompiled). Other platforms: source install.
- **Rust source is a password-protected zip** (`ext/.../rust_src.zip`) — IP protection. The password is
  plaintext in the MAIN repo (`secrets/mmg-hypersource-interface.rust-src.password`) for now; `extconf.rb`
  reads `MMG_RUST_SRC_PASSWORD` or that file to extract + compile. No password → Ruby peer still works.

A slot mounts EITHER `mmg-hypersource` (Ruby, portable, the oracle) OR this gem (Rust identity, fast).
