module Saline
  # A `Saturating` `Number` clamps to its maximum or minimum values instead of
  # overflowing.
  #
  # This wrapper type changes overflow behavior to saturate at the contained
  # `Number` type's minimum and maximum. The code snippet below demonstrates
  # this concept with an Int32.
  #
  # ```
  # n = Saturating(Int32).new(Int32::MAX - 2)
  # n += 20 # => 2147483647 (Int32::MAX)
  #
  # m = Saturating(Int32).new(Int32::MIN + 3)
  # m -= 30 # => -2147483648 (Int32::MIN)
  # ```
  #
  # Note: This class will only work with `Number` types. In order to avoid
  #       unexpected behavior, `T` is checked at compile-time to determine
  #       whether it is a `Number` type.
  struct Saturating(T)
    include Comparable(T)
    include Comparable(Saturating(T))
    include Comparable(Number)

    # The `Number` value represented by this `Saturating(T)`
    getter value : T

    # Create a new `Saturating(T)` with the given *value*.
    def initialize(@value : T)
      {% unless T < Number %}
      {% raise "The generic type of Saturating must be a Number type!" %}
    {% end %}
    end

    # Returns the result of adding `self` and *other*.
    # Returns `T::MAX` or `T::MIN` (as appropriate) in case of overflow.
    def +(other : Number) : Saturating(T)
      default_plus other
    end

    private def default_plus(other : Number) : Saturating(T)
      new_value = value + other
      Saturating(T).new(new_value)
    rescue OverflowError
      if other > 0
        Saturating(T).new(T::MAX)
      else
        Saturating(T).new(T::MIN)
      end
    end

    # Returns the result of subtracting *other* from `self`.
    # Returns `T::MAX` or `T::MIN` (as appropriate) in case of overflow.
    def -(other : Number) : Saturating(T)
      default_minus other
    end

    private def default_minus(other : Number) : Saturating(T)
      new_value = value - other
      Saturating(T).new(new_value)
    rescue OverflowError
      if other > 0
        Saturating(T).new(T::MIN)
      else
        Saturating(T).new(T::MAX)
      end
    end

    # Returns the result of multiplying `self` and *other*.
    # Returns `T::MAX` or `T::MIN` (as appropriate) in case of overflow.
    def *(other : Number) : Saturating(T)
      if ((-1..1).includes?(other) || (-1..1).includes?(value) || value <= T::MAX // other)
        new_value = value * other
        Saturating(T).new(new_value)
      else
        if (value < 0) ^ (other < 0) # this does cancelling of negative signs
          Saturating(T).new(T::MIN)
        else
          Saturating(T).new(T::MAX)
        end
      end
    end

    # Returns the result of adding `self` and *other*.
    # Returns `T::MAX` or `T::MIN` (as appropriate) in case of overflow.
    def +(other : Saturating) : Saturating(T)
      self + other.value
    end

    # Returns the result of subtracting *other* from `self`.
    # Returns `T::MAX` or `T::MIN` (as appropriate) in case of overflow.
    def -(other : Saturating) : Saturating(T)
      self - other.value
    end

    # Returns the result of multiplying `self` and *other*.
    # Returns `T::MAX` or `T::MIN` (as appropriate) in case of overflow.
    def *(other : Saturating) : Saturating(T)
      self * other.value
    end

    def <=>(other : Saturating(T))
      self.value <=> other.value
    end

    def <=>(other : Number)
      self.value <=> other
    end

    # TODO
    def saturated?
      saturated_to_min? || saturated_to_max?
    end

    # TODO
    def saturated_to_max?
      value == T::MAX
    end

    # TODO
    def saturated_to_min?
      value == T::MIN
    end
  end
end

# add type-specific methods
require "./saturating_ops"
