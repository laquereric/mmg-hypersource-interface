# mmg-hypersource-interface

The **opaque, drop-in** peer of `mmg-hypersource`. Registers the SAME hypersource MCB surface
(`Mmg::HypersourceInterface`, four actions) backed by an **opaque Rust native extension** (native speed,
hidden implementation). **Swap the Gemfile line** (`mmg-hypersource` → `mmg-hypersource-interface`) and a
slot gets the same grammar-in/graph-out surface, now Rust-backed.

- **Full contract for public consumers:** ships `grammar.bnf` (grammar-in) + `boundary.ttl` +
  **`shacl.ttl`** (graph-out shapes for `urn:mmg:hypersource:public`) — so a consumer holding only this gem
  can do grammar-in / graph-out fully, no ruby repo needed.
- **Opaque:** the Rust source ships only as a password-protected zip (`ext/.../rust_src.zip`); `extconf`
  extracts + compiles on a source install (`MMG_RUST_SRC_PASSWORD`), else skips (actions report
  `:native_unavailable`). Precompiled: darwin-arm64.
- **Specs live only in `mmg-hypersource`** (the ruby repo) — `spec/identity_parity_bench.rb` proves byte
  parity between the two peers before any build ships.
