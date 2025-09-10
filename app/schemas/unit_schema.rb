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
    {
      type: "object",
      required: %w[id name position_x position_y],
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
        }
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
        "$ref": "#/definitions/time_stamp"
      },
      updated_at: {
        "$ref": "#/definitions/time_stamp"
      },
      # This constraint prohibits extra fields in your JSON objects beyond what's defined in the schema.
      additionalProperties: false,
      # This constraint enforces naming conventions for any properties in the JSON object.
      # pass: id, position_x, unit_type
      # fail: ID, Position-X, 123property
      propertyNames: {
        pattern: "^[a-z_][a-z0-9_]*$"
      },
      examples: [
        {
          id: 1,
          name: "InfantryUnit",
          position_x: 123.45,
          position_y: 67.89,
          created_at: "2025-08-03T12:55:27Z",
          updated_at: "2025-08-03T12:55:27Z"
        }
      ]
    }
  end

  # Schema for units collection
  def self.collection
    {
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
    }
  end

  # Schema for a single unit response
  def self.single
    {
      type: "object",
      required: [ "units" ],
      properties: {
        units: { "$ref": "#/definitions/unit" }
      },
      additionalProperties: false
    }
  end
end
