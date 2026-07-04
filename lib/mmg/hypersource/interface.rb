# frozen_string_literal: true
require_relative "interface/version"
require_relative "interface/execute"

# mmg-hypersource-interface -- GRAMMAR REGISTRATION + Rust binary. Registers the deterministic identity
# surface (hypersource_identity / hypersource_variants) backed by the Rust native extension. Orchestration
# (open_arc / arc_for_brief) stays in mmg-hypersource (Ruby, graph-out/AR): a slot mounts ONE of the two.
module Mmg
  module Hypersource
    module Interface
      GRAMMAR  = ::File.expand_path("interface/grammar.bnf", __dir__)
      BOUNDARY = ::File.expand_path("interface/boundary.ttl", __dir__)

      module_function

      def mcb_actions
        [
          { name: "hypersource_identity", domain: "hypersource", personas: %w[superdev developer],
            describe: "Deterministic identity (arc/<id>/<engine>/<tuning>) via the Rust native ext. No side effects.",
            input_schema: { type: "object", properties: { arc_id: { type: "string" }, engine_config: { type: "string" }, tuning: { type: "string" } }, required: %w[arc_id] },
            handler: ->(i, _c) { { ok: true, arc_id: i[:arc_id], engine_config: i[:engine_config], tuning: i[:tuning], backend: :rust,
                                   branch: Execute.arc_branch(i[:arc_id], i[:engine_config], i[:tuning]),
                                   worktree: Execute.arc_worktree(i[:arc_id], i[:engine_config], i[:tuning]) } } },
          { name: "hypersource_variants", domain: "hypersource", personas: %w[superdev developer],
            describe: "Apples-to-apples comparison set (per engine/tuning) via the Rust native ext.",
            input_schema: { type: "object", properties: { arc_id: { type: "string" }, variants: { type: "array" } }, required: %w[arc_id variants] },
            handler: ->(i, _c) { { ok: true, arc_id: i[:arc_id], backend: :rust, variants: Execute.engine_variants(i[:arc_id], i[:variants]) } } }
        ]
      end
    end
  end
end
