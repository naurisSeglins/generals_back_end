# frozen_string_literal: true

require 'json'
require 'json-schema'
module JsonSchemaResponseValidator
  extend ActiveSupport::Concern

  def validate_response_with_schema(schema_class, schema_method)
    return unless Rails.env.test? || Rails.env.development?

    begin
      schema = schema_class.public_send(schema_method)

      # The response body is often a stream. After reading it (e.g., for JSON.parse),
      # the read 'cursor' is at the end. We need to rewind it so that the web server
      # (e.g., Puma) can read it again from the beginning to send it to the client.
      body = response.body
      response.body.rewind if response.body.respond_to?(:rewind)

      # The $schema key triggers a lookup in the gem that is failing.
      # We can safely remove it before validation as we are not meta-validating.
      schema_for_validation = schema.deep_dup
      schema_for_validation.delete("$schema")

      errors = JSON::Validator.fully_validate(schema_for_validation, JSON.parse(body), strict: true, validate_schema: false)

      return if errors.empty?

      # Log errors for easier debugging
      Rails.logger.error "JSON Schema Validation Errors for #{schema_class}##{schema_method}:"
      errors.each { |error| Rails.logger.error error }

      # In the test environment, it's better to fail fast.
      raise "JSON Schema Validation failed: #{errors.join(', ')}" if Rails.env.test?
    rescue => e
      Rails.logger.error "JSON Schema validation failed with exception: #{e.message}"
      raise if Rails.env.test?
    end
  end
end
