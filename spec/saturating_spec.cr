require "./spec_helper"

SUPPORTED_SINTS = [Int8, Int16, Int32, Int64]
SUPPORTED_UINTS = [UInt8, UInt16, UInt32, UInt64]
SUPPORTED_INTS  = [Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64]

describe Saturating do
  describe ".new" do
    it "disallows non-`Number` types" do
      assert_error(
        "compiler/saturating_only_numbers.cr",
        "The generic type of Saturating must be a Number type!"
      )
    end
  end

  {% for type in SUPPORTED_INTS %}
    describe ".new" do
      it "sets the {{type}} internal value based on the argument" do
        n = Saturating.new({{type}}.new 7)

        n.should eq 7
      end
    end

    describe "#+" do
      it "adds a {{type}} normally to Saturating({{type}})" do
        n = Saturating.new({{type}}.new 11)

        result = n + {{type}}.new(6)

        result.should eq 17
      end

      it "adds another Saturating({{type}}) normally" do
        n = Saturating.new({{type}}.new 19)
        m = Saturating.new({{type}}.new 4)

        result = n + m

        result.should eq 23
      end

      it "saturates to {{type}}::MAX when generic type would overflow" do
        n = Saturating.new({{type}}::MAX)

        result = n + 8

        result.should eq {{type}}::MAX
      end

      it "saturates to {{type}}::MIN when generic type would underflow" do
        n = Saturating.new({{type}}::MIN)

        result = n + -8

        result.should eq {{type}}::MIN
      end
    end

    describe "#-" do
      it "subtracts a {{type}} normally from Saturating({{type}})" do
        n = Saturating.new({{type}}.new 11)

        result = n - {{type}}.new(4)

        result.should eq 7
      end

      it "subtracts another Saturating({{type}}) normally" do
        n = Saturating.new({{type}}.new 19)
        m = Saturating.new({{type}}.new 6)

        result = n - m

        result.should eq 13
      end

      it "saturates to {{type}}::MAX when generic type would overflow" do
        n = Saturating.new({{type}}::MAX)

        result = n - -8

        result.should eq {{type}}::MAX
      end

      it "saturates to {{type}}::MIN when generic type would underflow" do
        n = Saturating.new({{type}}::MIN)

        result = n - 8

        result.should eq {{type}}::MIN
      end
    end

    describe "#*" do
      it "multiplies a {{type}} normally" do
        n = Saturating.new({{type}}.new 2)

        result = n * {{type}}.new(3)

        result.should eq 6
      end

      it "multiplies another Saturating({{type}}) normally" do
        n = Saturating.new({{type}}.new 5)
        m = Saturating.new({{type}}.new 7)

        result = n * m

        result.should eq 35
      end

      it "saturates to {{type}}::MAX when generic type would overflow" do
        n = Saturating.new({{type}}::MAX)

        result = n * 2

        result.should eq {{type}}::MAX
      end

      it "saturates to {{type}}::MIN when generic type would underflow" do
        n = Saturating.new({{type}}::MAX)

        result = n * -2

        result.should eq {{type}}::MIN
      end
    end
  {% end %}
end
