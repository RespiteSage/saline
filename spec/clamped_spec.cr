require "./spec_helper"

describe Clamped do
  describe ".new" do
    it "sets the internal value based on the argument" do
      n = Clamped(Int32, 2, 11).new 7

      n.should eq 7
    end

    it "disallows non-`Number` types" do
      assert_error(
        "compiler/clamped_only_numbers.cr",
        "The generic type of Clamped must be a Number type!"
      )
    end

    it "enforces numeric lower bound" do
      assert_error(
        "compiler/clamped_numeric_lower_bound.cr",
        "The generic lower bound of Clamped must be a number literal!"
      )
    end

    it "enforces numeric upper bound" do
      assert_error(
        "compiler/clamped_numeric_upper_bound.cr",
        "The generic upper bound of Clamped must be a number literal!"
      )
    end

    it "enforces partial ordering of lower and upper bounds" do
      assert_error(
        "compiler/clamped_bound_ordering.cr",
        "The generic upper bound of Clamped must not be less than its generic lower bound!"
      )
    end
  end

  describe "#+" do
    it "adds a Number normally" do
      n = Clamped(Int32, Int32::MIN, Int32::MAX).new 11

      result = n + 6

      result.should eq 17
    end

    it "adds another Clamped normally" do
      n = Clamped(Int32, Int32::MIN, Int32::MAX).new 19
      m = Clamped(Int32, Int32::MIN, Int32::MAX).new 4

      result = n + m

      result.should eq 23
    end

    # TODO: test Clamped with different generic types

    it "clamps when generic type would exceed upper bound" do
      n = Clamped(Int32, 2, 11).new 7

      result = n + 5

      result.should eq 11
    end

    it "clamps when generic type would exceed lower bound" do
      n = Clamped(Int32, 2, 11).new 7

      result = n + -11

      result.should eq 2
    end
  end

  describe "#-" do
    it "subtracts a Number normally" do
      n = Clamped(Int32, Int32::MIN, Int32::MAX).new 11

      result = n - 4

      result.should eq 7
    end

    it "subtracts another Clamped normally" do
      n = Clamped(Int32, Int32::MIN, Int32::MAX).new 19
      m = Clamped(Int32, Int32::MIN, Int32::MAX).new 6

      result = n - m

      result.should eq 13
    end

    # TODO: test Clamped with different generic types

    it "clamps when generic type would exceed upper bound" do
      n = Clamped(Int32, 2, 11).new 7

      result = n - -5

      result.should eq 11
    end

    it "clamps when generic type would exceed lower bound" do
      n = Clamped(Int32, 2, 11).new 7

      result = n - 11

      result.should eq 2
    end
  end

  describe "#*" do
    it "multiplies a Number normally" do
      n = Clamped(Int32, Int32::MIN, Int32::MAX).new 2

      result = n * 3

      result.should eq 6
    end

    it "multiplies another Clamped normally" do
      n = Clamped(Int32, Int32::MIN, Int32::MAX).new 5
      m = Clamped(Int32, Int32::MIN, Int32::MAX).new 7

      result = n * m

      result.should eq 35
    end

    # TODO: test Clamped with different generic types

    it "clamps when generic type would exceed upper bound" do
      n = Clamped(Int32, 0, 11).new 7

      result = n * 2

      result.should eq 11
    end

    it "clamps when generic type would exceed lower bound" do
      n = Clamped(Int32, 2, 11).new 7

      result = n * -1

      result.should eq 2
    end
  end
end
