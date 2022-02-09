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
end

SimpleCov.formatter = Codecov::SimpleCov::Formatter
