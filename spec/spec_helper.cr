require "spec"
require "../src/saline"

include Saline

# Asserts compile time errors given a *path* to a program and a *message*.
#
# This was copied straight from the spec_helper in
# [Athena](https://github.com/athena-framework/athena).
# This reuse was made under the MIT License, with the copyright held entirely
# by George Dietrich (as of 2020).
def assert_error(path : String, message : String) : Nil
  buffer = IO::Memory.new
  result = Process.run("crystal", ["run", "--no-color", "--no-codegen", "spec/" + path], error: buffer)
  fail buffer.to_s if result.success?
  buffer.to_s.should contain message
  buffer.close
end
