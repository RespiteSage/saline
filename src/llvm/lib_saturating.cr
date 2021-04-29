require "llvm"

module LLVM
  @[Link(ldflags: "-lLLVM")]
  # TODO
  lib LibSaturating
    {% begin %}
      {% for bit_width in {8, 16, 32, 64} %}
        fun sadd_i{{bit_width}} = "llvm.sadd.sat.i{{bit_width}}"(first : Int{{bit_width}}, second : Int{{bit_width}}) : Int{{bit_width}}
        fun uadd_i{{bit_width}} = "llvm.uadd.sat.i{{bit_width}}"(first : UInt{{bit_width}}, second : UInt{{bit_width}}) : UInt{{bit_width}}
        fun ssub_i{{bit_width}} = "llvm.ssub.sat.i{{bit_width}}"(first : Int{{bit_width}}, second : Int{{bit_width}}) : Int{{bit_width}}
        fun usub_i{{bit_width}} = "llvm.usub.sat.i{{bit_width}}"(first : UInt{{bit_width}}, second : UInt{{bit_width}}) : UInt{{bit_width}}
      {% end %}
    {% end %}
  end
end
