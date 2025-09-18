# frozen_string_literal: true

class ApiController < ApplicationController
  include JsonSchemaRequestValidator

  private

  # A helper method to standardize response rendering and validation.
  # It takes a resource, a status code, and optional schema validation parameters.
  def respond_with_resource(resource, status, schema_class: nil, schema_method: nil, **render_options)
    # 1. Explicitly serialize the resource into a Ruby hash using the provided serializer options.
    # ActiveModelSerializers::SerializableResource.new is the official, robust way to do this.
    serializable_resource = ActiveModelSerializers::SerializableResource.new(resource, render_options)
    resource_hash = serializable_resource.as_json

    # 2. Validate the Ruby hash against the schema if validation is requested.
    if schema_class && schema_method
      schema = schema_class.public_send(schema_method)
      # We still need our workaround to prevent the gem from making a failing web request.
      schema_for_validation = schema.deep_dup
      schema_for_validation.delete("$schema")
      errors = JSON::Validator.fully_validate(schema_for_validation, resource_hash, strict: true, validate_schema: false)

      # In the test environment, we want to fail loudly so we know immediately if a response is invalid.
      raise "JSON Schema Validation failed: #{errors.join(', ')}" if errors.present? && Rails.env.test?
    end

    # 3. Render the final, validated hash as JSON.
    render json: resource_hash, status: status
  end

  def respond_with_errors(errors, status: :unprocessable_entity)
    render json: { errors: errors }, status: status
  end
end
