# A `Saturating` `Number` clamps to its maximum or minimum values instead of
# overflowing.
#
# This wrapper type changes overflow behavior to saturate at the contained
# `Number` type's minimum and maximum. The code snippet below demonstrates
# this concept with an Int32.
#
# ```crystal
# n = Saturating(Int32).new(Int32::MAX)
# n += 1 # => 2147483647 (Int32::MAX)
# n = Saturating(Int32).new(Int32::MIN)
# n -= 1 # => -2147483648 (Int32::MIN)
# ```
#
# Note: This class will only work with `Number` types. In order to avoid
#       unexpected behavior, `T` is checked at compile-time to determine
#       whether it is a `Number` type.
struct Saturating(T)
  # The `Number` value represented by this `Saturating(T)`
  private getter value : T

  # Create a new `Saturating(T)` with the given *value*.
  def initialize(@value : T)
    {% unless T < Number %}
      {% raise "The generic type of Saturating must be a Number type!" %}
    {% end %}
  end

  # Returns the result of adding `self` and *other*.
  # Returns `T::MAX` or `T::MIN` (as appropriate) in case of overflow.
  def +(other : Number) : Saturating(T)
    if other < 0
      self - (-other)
    else
      begin
        new_value = value + other
        Saturating(T).new(new_value)
      rescue OverflowError
        Saturating(T).new(T::MAX)
      end
    end
  end

  # Returns the result of subtracting *other* from `self`.
  # Returns `T::MAX` or `T::MIN` (as appropriate) in case of overflow.
  def -(other : Number) : Saturating(T)
    if other < 0
      self + (-other)
    else
      begin
        new_value = value - other
        Saturating(T).new(new_value)
      rescue OverflowError
        Saturating(T).new(T::MIN)
      end
    end
  end

  # Returns the result of multiplying `self` and *other*.
  # Returns `T::MAX` or `T::MIN` (as appropriate) in case of overflow.
  def *(other : Number) : Saturating(T)
    begin
      new_value = value * other
      Saturating.new(new_value)
    rescue OverflowError
      if (value < 0) ^ (other < 0) # this does cancelling of negative signs
        Saturating(T).new(T::MIN)
      else
        Saturating(T).new(T::MAX)
      end
    end
  end

  # Returns the result of adding `self` and *other*.
  # Returns `T::MAX` or `T::MIN` (as appropriate) in case of overflow.
  def +(other : Saturating(T)) : Saturating(T)
    self + other.value
  end

  # Returns the result of subtracting *other* from `self`.
  # Returns `T::MAX` or `T::MIN` (as appropriate) in case of overflow.
  def -(other : Saturating(T)) : Saturating(T)
    self - other.value
  end

  # Returns the result of multiplying `self` and *other*.
  # Returns `T::MAX` or `T::MIN` (as appropriate) in case of overflow.
  def *(other : Saturating(T)) : Saturating(T)
    self * other.value
  end

  forward_missing_to value
end
