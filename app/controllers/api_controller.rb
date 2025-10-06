# frozen_string_literal: true

require "json-schema"

class ApiController < ApplicationController
  def respond_with_resource(resource, status, schema, output_schema: nil)
    # First serialize the units array with the UnitSerializer
    # json = ActiveModelSerializers::SerializableResource.new(resource, each_serializer: UnitSerializer).as_json
    json = ActiveModelSerializers::SerializableResource.new(resource).as_json

    # validation
    if output_schema
      errors = validate_output_schema(json, output_schema, schema)
      puts "errors #{errors}"
      return respond_with_errors(errors, status: 500) if errors
    end

    # Then wrap it in a hash with 'units' key and render
    render json: json, status: status
  end

  def respond_with_errors(errors, status: :unprocessable_entity)
    render json: { errors: errors }, status: status
  end

  # def validate_json_schema(data, schema_path)
  #   schemer = JSONSchemer.schema(Pathname.new(schema_path))
  #   errors = schemer.validate(data).to_a
  #   errors.empty? ? nil : errors
  # end

  def validate_output_schema(data, schema_path, schema)
    schemas = JSON.parse(File.read(Rails.root.join(schema_path)))

    JSON::Validator.validate(schemas, data, fragment: "#/definitions/#{schema}")
  end
end
