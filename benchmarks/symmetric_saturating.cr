require "benchmark"
require "../src/saline.cr"

include Saline

fake_val = 0
{% begin %}
  {% for type in {Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64} %}
    puts "{{type}}"
    Benchmark.ips do |x|
      x.report("Saturating({{type}}) + Saturating({{type}}), no saturation") do
        first_{{type}} = Saturating({{type}}).new(1)
        second_{{type}} = Saturating({{type}}).new(2)
        fake_val = first_{{type}} + second_{{type}}
      end

      x.report("Saturating({{type}}) - Saturating({{type}}), no saturation") do
        first_{{type}} = Saturating({{type}}).new(2)
        second_{{type}} = Saturating({{type}}).new(1)
        fake_val = first_{{type}} - second_{{type}}
      end

      x.report("Saturating({{type}}) * Saturating({{type}}), no saturation") do
        first_{{type}} = Saturating({{type}}).new(3)
        second_{{type}} = Saturating({{type}}).new(2)
        fake_val = first_{{type}} * second_{{type}}
      end

      x.report("Saturating({{type}}) + Saturating({{type}}), with saturation") do
        first_{{type}} = Saturating({{type}}).new({{type}}::MAX - 2)
        second_{{type}} = Saturating({{type}}).new({{type}}::MAX - 1)
        fake_val = first_{{type}} + second_{{type}}
      end

      x.report("Saturating({{type}}) - Saturating({{type}}), with saturation") do
        first_{{type}} = Saturating({{type}}).new({{type}}::MIN + 1)
        second_{{type}} = Saturating({{type}}).new(2)
        fake_val = first_{{type}} - second_{{type}}
      end

      x.report("Saturating({{type}}) * Saturating({{type}}), with saturation") do
        first_{{type}} = Saturating({{type}}).new({{type}}::MAX - 2)
        second_{{type}} = Saturating({{type}}).new({{type}}::MAX - 1)
        fake_val = first_{{type}} * second_{{type}}
      end
    end
    puts ""
  {% end %}
{% end %}
