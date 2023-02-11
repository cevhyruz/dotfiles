# vi:ft=ruby

require 'codecov'
require 'simplecov'

SimpleCov.start do
  add_filter [
    "test_lib/",
    ".git/",
  ]
  enable_coverage :branch
  SimpleCov.formatter = Codecov::SimpleCov::Formatter
end
