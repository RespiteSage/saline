module Saline
  # # A `Clamped` `Number` clamps to given minimum and maximum values.
  #
  # This wrapper type changes arithmetic behavior to clamp at the given lower
  # bound `L` and upper bound `U`. The code snippet below demonstrates
  # this concept with an Int32.
  #
  # ```crystal
  # n = Clamped(Int32, 2, 11).new(7)
  # n += 5 # => 11
  # n = Clamped(Int32, 2, 11).new(7)
  # n -= 11 # => 2
  # ```
  #
  # Note: This class will only work with `Number` types. In order to avoid
  #       unexpected behavior, `T` is checked at compile-time to determine
  #       whether it is a `Number` type.
  struct Clamped(T, L, U)
    include Comparable(T)
    include Comparable(Clamped(T, L, U))

    # The `Number` value represented by this `Clamped(T, L, U)`
    getter value : T

    # Create a new `Clamped(T, L, U)` with the given *value*.
    def initialize(@value : T)
      {% unless T < Number %}
        {% raise "The generic type of Clamped must be a Number type!" %}
      {% end %}
      {% unless L.is_a? NumberLiteral %}
        {% raise "The generic lower bound of Clamped must be a number literal!" %}
      {% end %}
      {% unless U.is_a? NumberLiteral %}
        {% raise "The generic upper bound of Clamped must be a number literal!" %}
      {% end %}
      {% if U < L %}
        {% raise "The generic upper bound of Clamped must not be less than its generic lower bound!" %}
      {% end %}

      # TODO: check initial value
    end

    # Returns the result of adding `self` and *other*.
    # Returns `U` or `L` (as appropriate) in case of overflow.
    def +(other : Number) : Clamped(T, L, U)
      if other < 0
        self - (-other)
      else
        begin
          if (new_value = value + other) <= U
            Clamped(T, L, U).new(new_value)
          else
            Clamped(T, L, U).new(U)
          end
        rescue OverflowError
          Clamped(T, L, U).new(U)
        end
      end
    end

    # Returns the result of subtracting *other* from `self`.
    # Returns `U` or `L` (as appropriate) in case of overflow.
    def -(other : Number) : Clamped(T, L, U)
      if other < 0
        self + (-other)
      else
        begin
          if (new_value = value - other) >= L
            Clamped(T, L, U).new(new_value)
          else
            Clamped(T, L, U).new(L)
          end
        rescue OverflowError
          Clamped(T, L, U).new(L)
        end
      end
    end

    # Returns the result of multiplying `self` and *other*.
    # Returns `U` or `L` (as appropriate) in case of overflow.
    def *(other : T) : Clamped(T, L, U)
      begin
        if (new_value = self.value * other) > U
          Clamped(T, L, U).new(U)
        elsif new_value < L
          Clamped(T, L, U).new(L)
        else
          Clamped(T, L, U).new(new_value)
        end
      rescue OverflowError
        if (value < 0) ^ (other < 0) # true if negative product, otherwise false
          Clamped(T, L, U).new(L)
        else
          Clamped(T, L, U).new(U)
        end
      end
    end

    # Returns the result of adding `self` and *other*.
    # Returns `U` or `L` (as appropriate) in case of overflow.
    def +(other : Clamped(T, L, U)) : Clamped(T, L, U)
      self + other.value
    end

    # Returns the result of subtracting *other* from `self`.
    # Returns `U` or `L` (as appropriate) in case of overflow.
    def -(other : Clamped(T, L, U)) : Clamped(T, L, U)
      self - other.value
    end

    # Returns the result of multiplying `self` and *other*.
    # Returns `U` or `L` (as appropriate) in case of overflow.
    def *(other : Clamped(T, L, U)) : Clamped(T, L, U)
      self * other.value
    end

    def <=>(other : Clamped(T, L, U))
      self.value <=> other.value
    end

    def <=>(other : Number)
      self.value <=> other
    end

    forward_missing_to value
  end
end
