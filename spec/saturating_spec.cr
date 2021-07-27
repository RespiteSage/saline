require "./spec_helper"

SUPPORTED_INTS          = [Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64]
SUPPORTED_OPERAND_TYPES = [Int8, Int16, Int32, Int64,
                           UInt8, UInt16, UInt32, UInt64]

describe Saturating do
  describe ".new" do
    it "disallows non-`Number` types" do
      assert_error(
        "compiler/saturating_only_numbers.cr",
        "The generic type of Saturating must be a Number type!"
      )
    end
  end

  {% for generic_type in SUPPORTED_INTS %}
    describe ".new" do
      it "sets the {{generic_type}} internal value based on the argument" do
        n = Saturating({{generic_type}}).new 7

        n.should eq 7
      end
    end

    describe "#+" do
      it "saturates to {{generic_type}}::MAX when {{generic_type}} would overflow" do
        n = Saturating.new({{generic_type}}::MAX)

        result = n + 8

        result.should eq {{generic_type}}::MAX
      end

      it "saturates to {{generic_type}}::MIN when {{generic_type}} would underflow" do
        n = Saturating.new({{generic_type}}::MIN)

        result = n + -8

        result.should eq {{generic_type}}::MIN
      end
    end

    describe "#-" do
      it "saturates to {{generic_type}}::MAX when {{generic_type}} would overflow" do
        n = Saturating.new({{generic_type}}::MAX)

        result = n - -8

        result.should eq {{generic_type}}::MAX
      end

      it "saturates to {{generic_type}}::MIN when {{generic_type}} would underflow" do
        n = Saturating.new({{generic_type}}::MIN)

        result = n - 8

        result.should eq {{generic_type}}::MIN
      end
    end

    describe "#*" do
      it "saturates to {{generic_type}}::MAX when {{generic_type}} would overflow" do
        n = Saturating.new({{generic_type}}::MAX)

        result = n * 2

        result.should eq {{generic_type}}::MAX
      end

      it "saturates to {{generic_type}}::MIN when {{generic_type}} would underflow" do
        n = Saturating.new({{generic_type}}::MAX)

        result = n * -2

        result.should eq {{generic_type}}::MIN
      end
    end

    {% for operand_type in SUPPORTED_OPERAND_TYPES %}
      describe "#+" do
        it "adds a {{operand_type}} normally to a Saturating({{generic_type}})" do
          n = Saturating({{generic_type}}).new 11

          result = n + {{operand_type}}.new(6)

          result.should eq 17
        end

        it "adds a Saturating({{operand_type}}) to a Saturating({{generic_type}}) normally" do
          n = Saturating({{generic_type}}).new 19
          m = Saturating({{operand_type}}).new 4

          result = n + m

          result.should eq 23
        end
      end

      describe "#-" do
        it "subtracts a {{operand_type}} normally from a Saturating({{generic_type}})" do
          n = Saturating({{generic_type}}).new 11

          result = n - {{operand_type}}.new(4)

          result.should eq 7
        end

        it "subtracts a Saturating({{operand_type}}) from a  Saturating({{generic_type}}) normally" do
          n = Saturating({{generic_type}}).new 19
          m = Saturating({{operand_type}}).new 6

          result = n - m

          result.should eq 13
        end
      end

      describe "#*" do
        it "multiplies a Saturating({{generic_type}}) by a {{operand_type}} normally" do
          n = Saturating({{generic_type}}).new 2

          result = n * {{operand_type}}.new(3)

          result.should eq 6
        end

        it "multiplies a Saturating({{generic_type}}) a Saturating({{operand_type}}) normally" do
          n = Saturating({{generic_type}}).new 5
          m = Saturating({{operand_type}}).new 7

          result = n * m

          result.should eq 35
        end
      end

      describe "#<=>" do
        it "returns 0 when a Saturating({{generic_type}}) equals a {{operand_type}}" do
          n = Saturating({{generic_type}}).new 7
          m = {{operand_type}}.new 7

          (n <=> m).should eq 0
        end

        it "returns 0 when a Saturating({{generic_type}}) equals a Saturating({{operand_type}})" do
          n = Saturating({{generic_type}}).new 7
          m = Saturating({{operand_type}}).new 7

          (n <=> m).should eq 0
        end

        it "returns 1 when a Saturating({{generic_type}}) is larger compared with a {{operand_type}}" do
          n = Saturating({{generic_type}}).new 8
          m = {{operand_type}}.new 7

          (n <=> m).should eq 1
        end

        it "returns 1 when a Saturating({{generic_type}}) is larger compared with a Saturating({{operand_type}})" do
          n = Saturating({{generic_type}}).new 8
          m = Saturating({{operand_type}}).new 7

          (n <=> m).should eq 1
        end

        it "returns -1 when a Saturating({{generic_type}}) is smaller compared with a {{operand_type}}" do
          n = Saturating({{generic_type}}).new 7
          m = {{operand_type}}.new 8

          (n <=> m).should eq -1
        end

        it "returns -1 when a Saturating({{generic_type}}) is smaller compared with a Saturating({{operand_type}})" do
          n = Saturating({{generic_type}}).new 7
          m = Saturating({{operand_type}}).new 8

          (n <=> m).should eq -1
        end
      end
    {% end %}
  {% end %}
end
