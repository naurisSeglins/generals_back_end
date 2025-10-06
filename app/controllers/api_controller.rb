# frozen_string_literal: true

require "json-schema"

class ApiController < ApplicationController
  def respond_with_resource(resource, status, schema, output_schema: nil)
    json = ActiveModelSerializers::SerializableResource.new(resource).as_json

    if output_schema
      errors = validate_output_schema(json, output_schema, schema)
      return respond_with_errors(errors, status: 500) if errors
    end

    render json: json, status: status
  end

  def respond_with_errors(errors, status: :unprocessable_entity)
    render json: { errors: errors }, status: status
  end

  def validate_output_schema(data, schema_path, schema)
    schemas = JSON.parse(File.read(Rails.root.join(schema_path)))
    begin
      JSON::Validator.validate!(schemas, data, fragment: "#/definitions/#{schema}")
      nil
    rescue JSON::Schema::ValidationError => e
      e.message
    end
  end
end
