# frozen_string_literal: true

class UnitLoggerService
  def initialize(logger = nil)
    @logger = logger || Logger.new(Rails.root.join("log/unit_creation.log").to_s)
  end

  def log_creation(unit)
    @logger.debug(build_log_message(unit))
  end

  private

  def build_log_message(unit)
    "New Unit##{unit.id} '#{unit.name}' created at #{unit.created_at}"
  end
end
