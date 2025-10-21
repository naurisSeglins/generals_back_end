source "https://rubygems.org"

ruby ">= 3.2.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.2.2", ">= 7.2.2.1"
# Use sqlite3 as the database for Active Record
gem "sqlite3", ">= 1.4"
# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder", "~> 2.12"
# Use Redis adapter to run Action Cable in production
gem "redis"

gem "sidekiq"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem "bcrypt"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.18", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
gem "rack-cors"

gem "strong_migrations"

gem "active_model_serializers", "~> 0.10.15"

gem "jsonapi_parameters", "~> 2.3" # allows `params.from_jsonapi.require(:model)`

gem "sorbet-runtime"

# JSON Schema validation
gem "json-schema"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"

  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false

  # Omakase Ruby styling [https://github.com/rails/rubocop-rails-omakase/]
  gem "rubocop-rails-omakase", require: false

  gem "rubocop", "~> 1.81.6", require: false
  gem "rubocop-rails", "~> 2.24", require: false
  gem "rubocop-rspec", "~> 2.29", require: false
end

group :development do
  gem "sorbet", "~> 0.5"
end

group :test do
  gem "rspec-rails" # CLI spec runner. `rspec spec/models/`
  gem "factory_bot_rails" # allows `create(:product)` etc. easy setup
  gem "shoulda-matchers" # allows `expect(model_instance).to have_many(:assocs)`
  gem "rails-controller-testing" # allows asserting `assigns` in request specs

  gem "simplecov", require: false # `COVERAGE=true rspec` to get spec coverage report
  gem "timecop" # allows `Timecop.freeze("2024-05-20 12:00")`
  gem "webmock", require: false # allows `stub_request(:any, "www.example.com")`
  gem "tapioca", require: false # CLI generator for sorbet RBI files
end
