# frozen_string_literal: true

class UnitQueryService
  def initialize(cache_service: UnitCacheService.new)
    @cache_service = cache_service
  end

  def all
    @cache_service.fetch_all_units { Unit.all.to_a }
  end

  def find(id)
    Unit.find(id)
  end
end
