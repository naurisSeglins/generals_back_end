# frozen_string_literal: true

require 'json'
require 'json-schema'
module JsonSchemaValidator
  extend ActiveSupport::Concern

  def validate_response(schema) end
end
