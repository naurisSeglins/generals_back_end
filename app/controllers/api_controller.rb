# frozen_string_literal: true

class ApiController < ApplicationController
  def respond_with_resource(resource, status, output_schema: nil)
    json = ActiveModelSerializers::SerializableResource.new(resource).as_json
    if output_schema
      errors = validate_output_schema(json, output_schema)
      puts "errors #{errors}"
      return respond_with_errors(errors, status: 500) if errors
    end

    render json: resource, status: status
  end

  def respond_with_errors(errors, status: :unprocessable_entity)
    render json: { errors: errors }, status: status
  end

  def validate_json_schema(data, schema_path)
    schemer = JSONSchemer.schema(Pathname.new(schema_path))
    errors = schemer.validate(data).to_a
    errors.empty? ? nil : errors
  end

  def validate_output_schema(data, schema_path)
    schemer = JSONSchemer.schema(Pathname.new(schema_path))
    errors = schemer.validate(data).to_a
    errors.empty? ? nil : errors
  end
end
