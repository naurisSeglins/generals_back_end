# frozen_string_literal: true

class UnitSchema
  def self.schema_version
    "https://json-schema.org/draft/2020-12/schema"
  end

  def self.definitions
    {
      id_integer: {
        type: "integer",
        minimum: 1,
        description: "Auto-incrementing integer ID"
      },
      coordinate: {
        type: "number",
        multipleOf: 0.01, # For 2 decimal places precision
        description: "Coordinate value (decimal type in database)",
        examples: 42.5
      },
      time_stamp: {
        type: "string",
        format: "date-time",
        description: "ISO8601 timestamp"
      }
    }
  end

  # Enhanced schema for a single unit with rich validation
  def self.unit
    build_schema(unit_definition)
  end

  # Schema for units collection
  def self.collection
    build_schema(
      type: "object",
      required: %w[units],
      properties: {
        units: {
          type: "array",
          items: { "$ref": "#/definitions/unit" },
          description: "List of units",
          minItems: 0,
          uniqueItems: true
        }
      },
      additionalProperties: false
    )
  end

  # Schema for a single unit response
  def self.single
    build_schema(
      type: "object",
      required: [ "unit" ],
      properties: {
        unit: { "$ref": "#/definitions/unit" }
      },
      additionalProperties: false
    )
  end

  # Schema for creating a new unit (request body)
  def self.create
    build_schema(
      type: "object",
      required: %w[name position_x position_y],
      properties: {
        name: { "$ref": "#/definitions/unit/properties/name" },
        position_x: { "$ref": "#/definitions/unit/properties/position_x" },
        position_y: { "$ref": "#/definitions/unit/properties/position_y" }
      },
      additionalProperties: false
    )
  end

  # Schema for updating a unit (request body)
  def self.update
    build_schema(
      type: "object",
      properties: {
        name: { "$ref": "#/definitions/unit/properties/name" },
        position_x: { "$ref": "#/definitions/unit/properties/position_x" },
        position_y: { "$ref": "#/definitions/unit/properties/position_y" }
      },
      additionalProperties: false,
      minProperties: 1
    )
  end

  # private

  def self.build_schema(main_schema)
    {
      "$schema" => schema_version
    }.merge(main_schema).merge(
      definitions: definitions.merge(
        unit: unit_definition
      )
    )
  end

  def self.unit_definition
    {
      type: "object",
      required: %w[id name position_x position_y created_at updated_at],
      properties: {
        id: {
          allOf: [
            { "$ref": "#/definitions/id_integer" },
            { description: "Unique identifier for the unit" }
          ]
        },
        name: {
          type: "string",
          minLength: 5,
          maxLength: 50,
          pattern: "^[a-zA-Z0-9]+$",
          description: "Name of the unit, alphanumeric"
        },
        position_x: {
          allOf: [
            { "$ref": "#/definitions/coordinate" },
            { description: "X coordinate of the unit in the game World" }
          ]
        },
        position_y: {
          allOf: [
            { "$ref": "#/definitions/coordinate" },
            { description: "Y coordinate of the unit in the game World" }
          ]
        },
        created_at: {
          type: "string",
          format: "date-time",
          description: "Timestamp of when the unit was created"
        },
        updated_at: {
          type: "string",
          format: "date-time",
          description: "Timestamp of when the unit was last updated"
        }
      },
      additionalProperties: false,
      propertyNames: {
        pattern: "^[a-z_][a-z0-9_]*$"
      }
    }
  end

  private_class_method :build_schema, :unit_definition
end
