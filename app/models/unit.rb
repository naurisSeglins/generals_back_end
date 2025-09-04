class Unit < ApplicationRecord
  validates :name, :position_x, :position_y, presence: true

  validates :name, format: { with: /\A[a-zA-Z0-9]+\z/, message: "entered doesn't match allowed format" }
  validates :name, length: { in: 5..50 }

  validates :position_x, :position_y, numericality: { allow_integer: true, allow_float: true, message: "entered value isn't a number" }

  after_create_commit :log_new_unit_creation

  private

  def log_new_unit_creation
    Logger.new(Rails.root.join("log/unit_creation.log").to_s)
          .debug("New Unit##{id} '#{name}' created at #{created_at}")
  end
end
