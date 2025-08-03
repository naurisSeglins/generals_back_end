# Mark existing migrations as safe
StrongMigrations.start_after = 20250803125811

# Set timeouts for migrations
StrongMigrations.lock_timeout = 10.seconds
StrongMigrations.statement_timeout = 1.hour

# Skip database checks for SQLite (not supported)
StrongMigrations.skip_database(:primary) if Rails.env.development? && ActiveRecord::Base.connection.adapter_name == 'SQLite'


# Analyze tables after indexes are added
# Outdated statistics can sometimes hurt performance
# Disabled for SQLite as it doesn't support analyze_table method
StrongMigrations.auto_analyze = false

# Set the version of the production database
# so the right checks are run in development
# StrongMigrations.target_version = 10

# Add custom checks
# StrongMigrations.add_check do |method, args|
#   if method == :add_index && args[0].to_s == "users"
#     stop! "No more indexes on the users table"
#   end
# end
