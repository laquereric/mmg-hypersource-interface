# frozen_string_literal: true
require_relative "hypersource_interface/version"
require_relative "hypersource_interface/execute"

# mmg-hypersource-interface -- the OPAQUE, discoverable, drop-in peer of mmg-hypersource. MmgFederation finds
# Mmg::HypersourceInterface (a direct Mmg constant that responds to mcb_actions) and registers the SAME four
# actions, so swapping the Gemfile line (mmg-hypersource -> mmg-hypersource-interface) yields the same MCB
# surface -- now Rust-backed. PUBLIC surface publishes ONLY W3C standards: SHACL (the data-shape grammar --
# accept-as-input + graph-out). The non-standard grammar.bnf and the boundary.ttl source stay INTERNAL to the
# (private) mmg-hypersource ruby gem, which derives this SHACL. A public consumer needs only the W3C SHACL.
module Mmg
  module HypersourceInterface
    # Published derived interfaces (no BNF source ships): SHACL (W3C data-shape grammar, hosted-provider tool
    # contract) + GBNF (llama.cpp/outlines grammar, LOCAL-model constrained decoding). A consumer targets any
    # model class from these: hosted via SHACL->JSON-Schema, local via the GBNF grammar.
    SHACL = ::File.expand_path("hypersource_interface/shacl.ttl", __dir__)
    GBNF  = ::File.expand_path("hypersource_interface/grammar.gbnf", __dir__)

    module_function

    def mcb_actions
      na = { ok: false, reason: :native_unavailable,
             because: "mmg-hypersource-interface native ext not built -- `rake compile` or install the arm64-darwin gem" }
      guard = ->(blk) { Execute.available? ? blk.call : na }
      [
        { name: "hypersource_open_arc", domain: "hypersource", personas: %w[superdev developer],
          describe: "Open an arc identity (Rust) + project it to urn:mmg:hypersource:public.",
          input_schema: { type: "object", properties: { title: { type: "string" } } },
          handler: ->(i, _c) { guard.call(-> { Execute.open_arc(title: i[:title]) }) } },
        { name: "hypersource_arc_for_brief", domain: "hypersource", personas: %w[superdev developer],
          describe: "The keystone: resolve a brief's arc/branch/worktree (Rust identity).",
          input_schema: { type: "object", properties: { brief_id: { type: "string" } }, required: %w[brief_id] },
          handler: ->(i, _c) { guard.call(-> { Execute.arc_for_brief(i[:brief_id]) }) } },
        { name: "hypersource_identity", domain: "hypersource", personas: %w[superdev developer],
          describe: "Deterministic identity (arc/<id>/<engine>/<tuning>) via the Rust native ext. No side effects.",
          input_schema: { type: "object", properties: { arc_id: { type: "string" }, engine_config: { type: "string" }, tuning: { type: "string" } }, required: %w[arc_id] },
          handler: ->(i, _c) { guard.call(-> { { ok: true, arc_id: i[:arc_id], engine_config: i[:engine_config], tuning: i[:tuning], backend: :rust,
                                                  branch: Execute.arc_branch(i[:arc_id], i[:engine_config], i[:tuning]),
                                                  worktree: Execute.arc_worktree(i[:arc_id], i[:engine_config], i[:tuning]) } }) } },
        { name: "hypersource_variants", domain: "hypersource", personas: %w[superdev developer],
          describe: "Apples-to-apples comparison set (per engine/tuning) via the Rust native ext.",
          input_schema: { type: "object", properties: { arc_id: { type: "string" }, variants: { type: "array" } }, required: %w[arc_id variants] },
          handler: ->(i, _c) { guard.call(-> { { ok: true, arc_id: i[:arc_id], backend: :rust, variants: Execute.engine_variants(i[:arc_id], i[:variants]) } }) } }
      ]
    end
  end
end
