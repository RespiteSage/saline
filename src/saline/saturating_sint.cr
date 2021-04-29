require "../llvm/lib_saturating"

module Saline
  struct Saturating(T)
    # Returns the result of adding `self` and *other*.
    # Returns `T::MAX` or `T::MIN` (as appropriate) in case of overflow.
    def +(other : Number) : Saturating(T)
      {% if [Int8, Int16, Int32, Int64].includes? T %}
        {% for bit_width in [8, 16, 32, 64] %}
          {% if T.stringify == "Int#{bit_width}" %}
            if (other.bit_length <= {{bit_width - 1}})
              Saturating(Int{{bit_width}}).new LLVM::LibSaturating.sadd_i{{bit_width}}(value, other.to_i{{bit_width}})
            else
              default_plus other
            end
          {% end %}
        {% end %}
      {% else %}
        default_plus other
      {% end %}
    end

    # Returns the result of subtracting *other* from `self`.
    # Returns `T::MAX` or `T::MIN` (as appropriate) in case of overflow.
    def -(other : Number) : Saturating(T)
      {% if [Int8, Int16, Int32, Int64].includes? T %}
        {% for bit_width in [8, 16, 32, 64] %}
          {% if T.stringify == "Int#{bit_width}" %}
            if (other.bit_length <= {{bit_width - 1}})
              Saturating(Int{{bit_width}}).new LLVM::LibSaturating.ssub_i{{bit_width}}(value, other.to_i{{bit_width}})
            else
              default_plus other
            end
          {% end %}
        {% end %}
      {% else %}
        default_plus other
      {% end %}
    end
  end
end
