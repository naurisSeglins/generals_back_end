# frozen_string_literal: true

class SchemaValidator
  def self.validate(data, schema_class, schema_type, options = {})
    default_options = {
      insert_defaults: true,
      validate_schema: true,
      errors_as_objects: true
    }

    merged_options = default_options.merge(options)
    schema = schema_class.send("#{schema_type}_schema")

    errors = JSON::Validator.fully_validate(schema, data, merged_options)

    if errors.any?
      if Rails.env.development?
        Rails.logger.error("Schema validation errors: #{errors.inspect}")
      end
      raise JSON::Schema::ValidationError, errors.first.to_s
    end

    true
  end
end
