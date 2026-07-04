# frozen_string_literal: true
require "net/http"
require "uri"
require "securerandom"

module Mmg
  module HypersourceInterface
    # OPAQUE Rust-backed identity. arc_branch/worktree/slug/variants run in the native ext
    # (MmgHypersourceNative) -- there is NO Ruby fallback (opacity + native speed are the point). Orchestration
    # (open_arc graph-out, arc_for_brief) is thin Ruby glue -- not the IP. Byte parity with the Ruby peer
    # (Mmg::Hypersource::Execute) is proven by specs that live ONLY in the mmg-hypersource repo.
    module Execute
      module_function
      ENDPOINT = ::ENV["MM_OXIGRAPH_URL"] || "http://localhost:7878"
      PUBLIC   = "urn:mmg:hypersource:public"

      def native  = (@native ||= (require "mmg_hypersource_identity"; ::MmgHypersourceNative))
      def available?
        native
        true
      rescue ::LoadError
        false
      end

      def engine_slug(part)                      = native.engine_slug(part)
      def config_segments(engine_config, tuning) = native.config_segments(engine_config, tuning)
      def arc_branch(arc_id, e = nil, t = nil)   = native.arc_branch(arc_id.to_s, e, t)
      def arc_worktree(arc_id, e = nil, t = nil) = native.arc_worktree(arc_id.to_s, e, t)
      def engine_variants(arc_id, variants)
        ::Kernel.Array(variants).map do |v|
          ec, tn = v.is_a?(::Hash) ? [v["engine_config"] || v[:engine_config], v["tuning"] || v[:tuning]] : [v, nil]
          { engine_config: ec, tuning: tn, branch: arc_branch(arc_id, ec, tn), worktree: arc_worktree(arc_id, ec, tn) }
        end
      end
      def generate_arc_id = "arc_#{::Time.now.utc.strftime('%Y-%m-%d')}_#{::SecureRandom.hex(4)}"

      def arc_for_brief(brief_id)
        return { ok: false, reason: :unmounted, because: "::Mm::Brief unavailable" } unless defined?(::Mm::Brief)
        b = ::Mm::Brief.find_by(id: brief_id.to_s)
        return { ok: false, reason: :no_brief, because: "no Mm::Brief #{brief_id}" } unless b
        arc = b.arc_id
        { ok: true, brief_id: b.id, arc_id: arc, branch: (arc ? arc_branch(arc) : nil), worktree: (arc ? arc_worktree(arc) : nil) }
      rescue => e
        { ok: false, reason: :keystone_failed, because: "#{e.class}: #{e.message}" }
      end

      def open_arc(title: nil)
        id = generate_arc_id
        branch = arc_branch(id)
        worktree = arc_worktree(id)
        publish_arc(id, branch, worktree)
        { ok: true, arc_id: id, branch: branch, worktree: worktree, title: title, backend: :rust }
      end

      def publish_arc(id, branch, worktree)
        body = ["<urn:mmg:hypersource:arc:#{id}> a <urn:mm:grammar:hypersource#Arc> .",
                "<urn:mmg:hypersource:arc:#{id}> <urn:mm:grammar:hypersource#branch> #{branch.inspect} .",
                "<urn:mmg:hypersource:arc:#{id}> <urn:mm:grammar:hypersource#worktree> #{worktree.inspect} ."].join("\n")
        ::Net::HTTP.post(::URI.parse("#{ENDPOINT}/update"), "INSERT DATA { GRAPH <#{PUBLIC}> {\n#{body}\n} }", "Content-Type" => "application/sparql-update")
      rescue StandardError
        nil
      end
    end
  end
end
