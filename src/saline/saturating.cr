struct Saturating(T)
  private getter value : T

  def initialize(@value : T)
    {% unless T < Number %}
      {% raise "The generic type of Saturating must be a Number type!" %}
    {% end %}
  end

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

  def +(other : Saturating(T)) : Saturating(T)
    self + other.value
  end

  def -(other : Saturating(T)) : Saturating(T)
    self - other.value
  end

  def *(other : Saturating(T)) : Saturating(T)
    self * other.value
  end

  forward_missing_to value
end
