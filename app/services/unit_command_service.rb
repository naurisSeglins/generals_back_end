# frozen_string_literal: true

class UnitCommandService
  class CreationError < StandardError; end
  class UpdateError < StandardError; end

  def create(params)
    unit = Unit.new(params)

    if unit.save
      unit
    else
      raise CreationError, unit.errors.full_messages.join(", ")
    end
  end

  def update(id, params)
    unit = Unit.find(id)

    if unit.update(params)
      unit
    else
      raise UpdateError, unit.errors.full_messages.join(", ")
    end
  end

  def destroy(id)
    unit = Unit.find(id)
    unit.destroy
  end
end
