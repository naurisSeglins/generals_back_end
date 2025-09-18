# frozen_string_literal: true

require "json"
require "json-schema"

module JsonSchemaRequestValidator
  extend ActiveSupport::Concern

  included do
    # This class method allows us to easily set up a before_action
    # in our controllers to validate the request body against a schema.
    # Example usage in a controller:
    #   validate_request_schema UnitSchema, :create, only: [:create]
    def self.validate_request_schema(schema_class, schema_method, options = {})
      before_action(options) do
        validate_request_body_against_schema(schema_class, schema_method)
      end
    end
  end

  private

  def validate_request_body_against_schema(schema_class, schema_method)
    begin
      schema = schema_class.public_send(schema_method)
      request_body = request.body.read
      # Rewind the body in case other parts of the app (or Rails itself) need to read it.
      request.body.rewind

      # The $schema key triggers a lookup in the gem that is failing.
      # We can safely remove it before validation as we are not meta-validating.
      schema_for_validation = schema.deep_dup
      schema_for_validation.delete("$schema")

      errors = JSON::Validator.fully_validate(schema_for_validation, JSON.parse(request_body), strict: true, validate_schema: false)

      return if errors.empty?

      # If validation fails, we stop the request and render a 422 Unprocessable Entity
      # response with the details of the validation errors.
      respond_with_errors(errors, status: :unprocessable_entity)
    rescue JSON::ParserError => e
      # If the request body is not valid JSON, we can't process it.
      # We stop the request and render a 400 Bad Request response.
      respond_with_errors(["Invalid JSON in request body: #{e.message}"], status: :bad_request)
    rescue => e
      # Catch any other unexpected errors during the validation process.
      Rails.logger.error "JSON Schema request validation failed with exception: #{e.message}"
      respond_with_errors(["An unexpected error occurred during request validation."], status: :internal_server_error)
    end
  end
end
