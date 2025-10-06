require 'simplecov_config' if ENV["COVERAGE"]

ENV["RAILS_ENV"] ||= "test"

require_relative '../config/environment'

abort("The Rails environment is running on production") if Rails.env.production?

require "rspec/rails"
require "webmock/rspec"
require "sidekiq/testing"
Sidekiq::Testing.fake!

Rails.root.glob("spec/support/**/*.rb").sort.each { |f| require f }

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

=begin
  Without infer_spec_type_from_file_location! option enabled,
  you would need to explicitly
  add metadata to your specs like:
  describe MyModel, type: :model do
    # tests
  end
  with infer_spec_type_from_file_location!
  describe MyModel do
    # tests
  end
=end
  config.infer_spec_type_from_file_location!

=begin
This RSpec configuration option cleans up error backtraces
in your test output by filtering out framework noise from
Rails gems. It makes test failures more readable.
=end
  config.filter_rails_from_backtrace!

=begin
   More explicit about where testing methods are
   coming from whether using RSpec functionality
   or regular Ruby
=end
  config.disable_monkey_patching!

=begin
   When use_transactional_fixtures is set to true,
   RSpec wraps each example in a database transaction.
   After the example finishes, the transaction is rolled back,
   so any records created during the test are removed automatically.
   This provides a clean database state both before and after each test without any extra code.
=end
  config.use_transactional_fixtures = true

  # Sets the default URL host value to "example.com" specifically for request specs
  config.before(:each, type: :request) do
    host! "example.com"
  end

  # Creates a new matcher called not_change that is the logical opposite of the standard change matcher
  RSpec::Matchers.define_negated_matcher :not_change, :change
  # Creates a new matcher called exclude that is the logical opposite of the standard include matcher
  RSpec::Matchers.define_negated_matcher :exclude, :include
  # expect(array).to include(item) and expect(array).to contain(item) would do the same thing
  RSpec::Matchers.alias_matcher :contain, :include

  # Shoulda Matchers essentially helps you write more thorough tests with less code
  # while following Rails testing best practices.
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end

=begin
  Not sure whether I need these or not:
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
=end
end
