require "benchmark"
require "../src/saline.cr"

include Saline

fake_val = 0
{% begin %}
  {% for first_type in {Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64} %}
    {% for second_type in ([Int8, Int16, Int32, Int64, UInt8, UInt16, UInt32, UInt64].reject { |type| type == first_type }) %}
      puts "{{first_type}} and {{second_type}}"
      Benchmark.ips do |x|
        x.report("{{first_type}} + {{second_type}}, (no overflow)") do
          val_{{first_type}} = 1
          val_{{second_type}} = 2
          fake_val = val_{{first_type}} + val_{{second_type}}
        end

        x.report("{{first_type}} - {{second_type}}, (no overflow)") do
          val_{{first_type}} = 2
          val_{{second_type}} = 1
          fake_val = val_{{first_type}} - val_{{second_type}}
        end

        x.report("{{first_type}} * {{second_type}}, (no overflow)") do
          val_{{first_type}} = 3
          val_{{second_type}} = 2
          fake_val = val_{{first_type}} * val_{{second_type}}
        end

        x.report("Saturating({{first_type}}) + Saturating({{second_type}}), no saturation") do
          val_{{first_type}} = Saturating({{first_type}}).new(1)
          val_{{second_type}} = Saturating({{second_type}}).new(2)
          fake_val = val_{{first_type}} + val_{{second_type}}
        end

        x.report("Saturating({{first_type}}) - Saturating({{second_type}}), no saturation") do
          val_{{first_type}} = Saturating({{first_type}}).new(2)
          val_{{second_type}} = Saturating({{second_type}}).new(1)
          fake_val = val_{{first_type}} - val_{{second_type}}
        end

        x.report("Saturating({{first_type}}) * Saturating({{second_type}}), no saturation") do
          val_{{first_type}} = Saturating({{first_type}}).new(3)
          val_{{second_type}} = Saturating({{second_type}}).new(2)
          fake_val = val_{{first_type}} * val_{{second_type}}
        end

        x.report("Saturating({{first_type}}) + Saturating({{second_type}}), with saturation") do
          val_{{first_type}} = Saturating({{first_type}}).new({{first_type}}::MAX - 2)
          val_{{second_type}} = Saturating({{second_type}}).new({{second_type}}::MAX - 1)
          fake_val = val_{{first_type}} + val_{{second_type}}
        end

        x.report("Saturating({{first_type}}) - Saturating({{second_type}}), with saturation") do
          val_{{first_type}} = Saturating({{first_type}}).new({{first_type}}::MIN + 1)
          val_{{second_type}} = Saturating({{second_type}}).new({{second_type}}::MAX)
          fake_val = val_{{first_type}} - val_{{second_type}}
        end

        x.report("Saturating({{first_type}}) * Saturating({{second_type}}), with saturation") do
          val_{{first_type}} = Saturating({{first_type}}).new({{first_type}}::MAX - 2)
          val_{{second_type}} = Saturating({{second_type}}).new({{second_type}}::MAX - 1)
          fake_val = val_{{first_type}} * val_{{second_type}}
        end
      end
      puts ""
    {% end %}
  {% end %}
{% end %}
