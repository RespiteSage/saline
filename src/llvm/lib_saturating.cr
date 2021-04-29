require "llvm"

module LLVM
  @[Link(ldflags: "-lLLVM")]
  # TODO
  lib LibSaturating
    {% begin %}
      {% for bit_width in {8, 16, 32, 64} %}
        fun iadd_{{bit_width}} = "llvm.sadd.sat.i{{bit_width}}"(first : Int{{bit_width}}, second : Int{{bit_width}}) : Int{{bit_width}}
        fun uadd_{{bit_width}} = "llvm.uadd.sat.i{{bit_width}}"(first : UInt{{bit_width}}, second : UInt{{bit_width}}) : UInt{{bit_width}}
        fun isub_{{bit_width}} = "llvm.ssub.sat.i{{bit_width}}"(first : Int{{bit_width}}, second : Int{{bit_width}}) : Int{{bit_width}}
        fun usub_{{bit_width}} = "llvm.usub.sat.i{{bit_width}}"(first : UInt{{bit_width}}, second : UInt{{bit_width}}) : UInt{{bit_width}}
      {% end %}
    {% end %}
  end
end
