$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "test_performance"
require "watir"

RSpec.configure do |config|
  config.disable_monkey_patching!
end
