# frozen_string_literal: true

class Unit < ApplicationRecord
  # Single Responsibility: Data validation and persistence

  validates :name, :position_x, :position_y, presence: true
  validates :name,
            format: { with: /\A[a-zA-Z0-9]+\z/, message: "entered doesn't match allowed format" },
            length: { in: 5..50 }
  validates :position_x, :position_y,
            numericality: {
              allow_integer: true,
              allow_float: true,
              message: "entered value isn't a number"
            }

  # Callbacks delegate to observer
  after_create_commit :notify_observer_after_create
  after_save :notify_observer_after_save
  after_destroy :notify_observer_after_destroy

  private

  def notify_observer_after_create
    observer.after_create(self)
  end

  def notify_observer_after_save
    observer.after_save(self)
  end

  def notify_observer_after_destroy
    observer.after_destroy(self)
  end

  def observer
    @observer ||= UnitObserver.new
  end
end
