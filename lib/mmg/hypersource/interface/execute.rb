# frozen_string_literal: true

module Mmg
  module Hypersource
    module Interface
      # The RUST-backed identity Execute. Delegates the deterministic surface to the compiled native ext
      # (MmgHypersourceNative). Byte parity with Mmg::Hypersource::Execute (the Ruby peer) is enforced by
      # mmg-hypersource/spec/identity_parity_bench.rb before any build ships.
      module Execute
        module_function

        def native
          @native ||= (require "mmg_hypersource_identity"; ::MmgHypersourceNative)
        end

        def available?
          native
          true
        rescue ::LoadError
          false
        end

        def engine_slug(part)                      = native.engine_slug(part)
        def config_segments(engine_config, tuning) = native.config_segments(engine_config, tuning)
        def arc_branch(arc_id, engine_config = nil, tuning = nil)   = native.arc_branch(arc_id.to_s, engine_config, tuning)
        def arc_worktree(arc_id, engine_config = nil, tuning = nil) = native.arc_worktree(arc_id.to_s, engine_config, tuning)

        def engine_variants(arc_id, variants)
          ::Kernel.Array(variants).map do |v|
            ec, tn = v.is_a?(::Hash) ? [v["engine_config"] || v[:engine_config], v["tuning"] || v[:tuning]] : [v, nil]
            { engine_config: ec, tuning: tn, branch: arc_branch(arc_id, ec, tn), worktree: arc_worktree(arc_id, ec, tn) }
          end
        end
      end
    end
  end
end
