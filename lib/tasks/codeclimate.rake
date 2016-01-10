namespace :codeclimate do
  desc 'Send coverage report'
  task :send_report do
    require 'simplecov'
    require 'codeclimate-test-reporter'
    CodeClimate::TestReporter::Formatter.new.format(SimpleCov.result)
  end
end