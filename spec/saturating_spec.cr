require "./spec_helper"

describe Saturating do
  describe ".new" do
    it "sets the internal value based on the argument" do
      n = Saturating(Int32).new 7

      n.should eq 7
    end

    it "disallows non-`Number` types" do
      assert_error(
        "compiler/saturating_only_numbers.cr",
        "The generic type of Saturating must be a Number type!"
      )
    end
  end

  describe "#+" do
    it "adds a Number normally" do
      n = Saturating(Int32).new 11

      result = n + 6

      result.should eq 17
    end

    it "adds another Saturating normally" do
      n = Saturating(Int32).new 19
      m = Saturating(Int32).new 4

      result = n + m

      result.should eq 23
    end

    # TODO: test Saturating with different generic types

    it "saturates when generic type would overflow" do
      n = Saturating(Int32).new 2_000_000_000

      result = n + 200_000_000

      result.should eq Int32::MAX
    end

    it "saturates when generic type would underflow" do
      n = Saturating(Int32).new -2_000_000_000

      result = n + -200_000_000

      result.should eq Int32::MIN
    end
  end

  describe "#-" do
    it "subtracts a Number normally" do
      n = Saturating(Int32).new 11

      result = n - 4

      result.should eq 7
    end

    it "subtracts another Saturating normally" do
      n = Saturating(Int32).new 19
      m = Saturating(Int32).new 6

      result = n - m

      result.should eq 13
    end

    # TODO: test Saturating with different generic types

    it "saturates when generic type would overflow" do
      n = Saturating(Int32).new 2_000_000_000

      result = n - -200_000_000

      result.should eq Int32::MAX
    end

    it "saturates when generic type would underflow" do
      n = Saturating(Int32).new -2_000_000_000

      result = n - 200_000_000

      result.should eq Int32::MIN
    end
  end

  describe "#*" do
    it "multiplies a Number normally" do
      n = Saturating(Int32).new 2

      result = n * 3

      result.should eq 6
    end

    it "multiplies another Saturating normally" do
      n = Saturating(Int32).new 5
      m = Saturating(Int32).new 7

      result = n * m

      result.should eq 35
    end

    # TODO: test Saturating with different generic types

    it "saturates when generic type would overflow" do
      n = Saturating(Int32).new 2_000_000_000

      result = n * 2

      result.should eq Int32::MAX
    end

    it "saturates when generic type would underflow" do
      n = Saturating(Int32).new 2_000_000_000

      result = n * -2

      result.should eq Int32::MIN
    end
  end
end
