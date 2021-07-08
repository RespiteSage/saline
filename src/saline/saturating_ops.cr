require "../llvm/lib_saturating"

module Saline
  struct Saturating(T)
    # Returns the result of adding `self` and *other*.
    # Returns `T::MAX` or `T::MIN` (as appropriate) in case of overflow.
    def +(other : Number) : Saturating(T)
      {% if [Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64].includes? T %}
        {% for type_base in ["Int", "UInt"] %}
        {% sign_char = type_base.id.stringify[0..0].downcase %}
        {% for bit_width in [8, 16, 32, 64] %}
            {% compatible_bit_length = (type_base == "Int") ? bit_width - 1 : bit_width %}
            {% if T.stringify == "#{type_base.id}#{bit_width}" %}
              if other.bit_length <= {{compatible_bit_length}}
                Saturating({{type_base.id}}{{bit_width}}).new LLVM::LibSaturating.{{sign_char.id}}add_{{bit_width}}(value, other.to_{{sign_char.id}}{{bit_width}})
              elsif other.bit_length > {{bit_width}}
                if other > 0
                  return Saturating(T).new T::MAX
                else
                  return Saturating(T).new T::MIN
                end
              else
                default_plus other
              end
            {% end %}
          {% end %}
        {% end %}
      {% else %}
        default_plus other
      {% end %}
    end

    # Returns the result of subtracting *other* from `self`.
    # Returns `T::MAX` or `T::MIN` (as appropriate) in case of overflow.
    def -(other : Number) : Saturating(T)
      {% if [Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64].includes? T %}
        {% for type_base in ["Int", "UInt"] %}
        {% sign_char = type_base.id.stringify[0..0].downcase %}
        {% for bit_width in [8, 16, 32, 64] %}
            {% compatible_bit_length = (type_base == "Int") ? bit_width - 1 : bit_width %}
            {% if T.stringify == "#{type_base.id}#{bit_width}" %}
              if other.bit_length <= {{compatible_bit_length}}
                Saturating({{type_base.id}}{{bit_width}}).new LLVM::LibSaturating.{{sign_char.id}}sub_{{bit_width}}(value, other.to_{{sign_char.id}}{{bit_width}})
              elsif other.bit_length > {{bit_width}}
                if other > 0
                  return Saturating(T).new T::MIN
                else
                  return Saturating(T).new T::MAX
                end
              else
                default_minus other
              end
            {% end %}
          {% end %}
        {% end %}
      {% else %}
        default_minus other
      {% end %}
    end
  end
end
