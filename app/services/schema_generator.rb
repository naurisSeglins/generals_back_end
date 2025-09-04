# frozen_string_literal: true

class SchemaGenerator
  # Helper method for schema generation
  def self.generate_schema_file(filename = nil)
    filename ||= Rails.root.join("doc", "schemas", "unit_schema.json")

    # Ensure directory exists
    FileUtils.mkdir_p(File.dirname(filename))

    full_schema = {
      "$schema": schema_version,
      title: "Unit Schemas",
      description: "JSON Schema definitions for Unit resources",
      definitions: definitions,
      unit: unit,
      collection: collection,
      single: single
    }

    File.write(filename, JSON.pretty_generate(full_schema))
    puts "Schema written to #{filename}"

    filename
  end
end
