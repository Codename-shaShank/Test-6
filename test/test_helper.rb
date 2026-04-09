ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

# minitest 6.x changed Runnable.run from (reporter, options={}) to (klass, method_name, reporter).
# Patch Rails::LineFiltering to match the new signature so the arity error is resolved.
# Filter composition is moved to run_suite where options are still available.
module Rails
  module LineFiltering
    # Redefines the class method to accept minitest 6.x's (klass, method_name, reporter)
    # signature, preventing Rails 7.0's incompatible 2-argument override from being invoked.
    def run(klass, method_name, reporter)
      super
    end

    def run_suite(reporter, options = {})
      options[:include] = Rails::TestUnit::Runner.compose_filter(self, options[:include])
      super
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
