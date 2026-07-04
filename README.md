# mmg-hypersource-interface

The **opaque, drop-in** peer of `mmg-hypersource`. Registers the SAME hypersource MCB surface
(`Mmg::HypersourceInterface`, four actions) backed by an **opaque Rust native extension** (native speed,
hidden implementation). **Swap the Gemfile line** (`mmg-hypersource` → `mmg-hypersource-interface`) and a
slot gets the same grammar-in/graph-out surface, now Rust-backed.

- **W3C-only public contract:** ships **only `shacl.ttl`** — the W3C SHACL data-shape grammar, covering both
  directions (IN shapes = accept-as-API-input; OUT shapes = the `urn:mmg:hypersource:public` graph-out). A
  public consumer validates in and out from this standard alone. The non-standard `grammar.bnf` (BNF) and the
  `boundary.ttl` source stay INTERNAL to the private `mmg-hypersource` ruby gem, which *derives* this SHACL.
- **Opaque:** the Rust source ships only as a password-protected zip (`ext/.../rust_src.zip`); `extconf`
  extracts + compiles on a source install (`MMG_RUST_SRC_PASSWORD`), else skips (actions report
  `:native_unavailable`). Precompiled: darwin-arm64.
- **Specs live only in `mmg-hypersource`** (the ruby repo) — `spec/identity_parity_bench.rb` proves byte
  parity between the two peers before any build ships.
