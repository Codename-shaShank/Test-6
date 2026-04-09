ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# Rails 7.0's LineFiltering#run(reporter, options) conflicts with minitest 6.0's
# new run(klass, method_name, reporter) signature. In minitest 6.0, the suite-level
# runner was renamed to run_suite. Override run_suite instead and remove the old run.
if Gem::Version.new(Minitest::VERSION) >= Gem::Version.new("6.0")
  module Rails
    module LineFiltering
      remove_method :run if method_defined?(:run)
      def run_suite(reporter, options = {})
        options[:filter] = Rails::TestUnit::Runner.compose_filter(self, options[:filter])
        super
      end
    end
  end
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
