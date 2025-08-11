class Unit < ApplicationRecord
  validates :name, :position_x, :position_y, presence: true

  validates :name, format: { with: /\A[a-zA-Z0-9]+\z/, message: "entered doesn't match allowed format" }
  validates :position_x, :position_y, numericality: { allow_integer: true, allow_float: true, message: "entered value isn't a number" }

  # validate :validate_position_values

  after_create_commit :log_new_unit_creation

  def to_s
    "name: #{name}, position_x: #{position_x}, position_y: #{position_y}"
  end

  private

  def log_new_unit_creation
    Rails.logger.tagged("UnitCreation") do
      Rails.logger.info("New unit #{id} '#{name}' created at #{created_at}")
    end
  end

  def validate_position_values
    validate_numeric_format(:position_x)
    validate_numeric_format(:position_y)
  end

  def validate_numeric_format(attribute)
    puts position_y_before_type_cast
    value = self.send("#{attribute}_before_type_cast")
    puts value
    puts value.is_a?(String)

    return unless value.is_a?(String)

    unless value.match?(/\A-?\d+(\.\d+)?\z/)
      errors.add(attribute, "entered value '#{value}' isn't a valid number")
    end
  end
end
