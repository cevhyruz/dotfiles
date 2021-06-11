require 'codecov'
require 'simplecov'

SimpleCov.start do
  add_filter 'test_lib'
  add_filter '.git'
  add_filter 'Bash/template'
end

SimpleCov.formatter = Codecov::SimpleCov::Formatter
