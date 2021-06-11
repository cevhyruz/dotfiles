require 'codecov'
require 'simplecov'

SimpleCov.start 'rails' do
  SimpleCov.formatter = Codecov::SimpleCov::Formatter
  add_filter 'test_lib'
  add_filter '.git'
  add_filter 'Bash/template'
end
