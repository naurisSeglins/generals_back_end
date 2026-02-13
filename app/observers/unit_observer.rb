# frozen_string_literal: true

class UnitObserver
  def initialize(
    cache_service: UnitCacheService.new,
    logger_service: UnitLoggerService.new
  )
    @cache_service = cache_service
    @logger_service = logger_service
  end

  def after_create(unit)
    @logger_service.log_creation(unit)
  end

  def after_save(_unit)
    @cache_service.expire
  end

  def after_destroy(_unit)
    @cache_service.expire
  end
end
