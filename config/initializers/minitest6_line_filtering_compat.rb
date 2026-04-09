# Rails 7.0.x LineFiltering patches Minitest::Runnable.run with the
# minitest 5.x signature: run(reporter, options = {}).
# Minitest 6.x changed this to run(klass, method_name, reporter) for
# running a single test, and introduced run_suite(reporter, options)
# as the new entry point for running all tests in a class.
# This patch adapts LineFiltering to work with minitest >= 6.0.
require "minitest"

if Gem::Version.new(Minitest::VERSION) >= Gem::Version.new("6.0")
  require "rails/test_unit/line_filtering"
  require "rails/test_unit/runner"

  Rails::LineFiltering.module_eval do
    remove_method :run if instance_methods(false).include?(:run)

    def run_suite(reporter, options = {})
      options[:include] = Rails::TestUnit::Runner.compose_filter(self, options[:include])
      super
    end
  end
end
