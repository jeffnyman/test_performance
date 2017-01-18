#!/usr/bin/env ruby
$: << "./lib"

require "test_performance"
require "watir"

b = Watir::Browser.new
b.goto "google.com"
p b.performance
b.close
