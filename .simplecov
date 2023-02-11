# vi:ft=ruby

require 'codecov'
require 'simplecov'

SimpleCov.start do
  add_filter [
    "test_lib/",
    ".git/",
    "Bash/template/",
    "hooks/",
    "Bash/functions/"
  ]
  enable_coverage :branch
  SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
    Codecov::SimpleCov::Formatter,
    SimpleCovSmallBadge::Formatter
  ])
end

SimpleCovSmallBadge.configure do |config|
  config.rounded_border = true
  config.background = '#ffffcc'
end
