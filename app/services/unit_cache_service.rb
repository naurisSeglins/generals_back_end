# frozen_string_literal: true

class UnitCacheService
  CACHE_KEY = "all_units"
  CACHE_EXPIRATION = 12.hours

  def initialize(cache_store = Rails.cache)
    @cache = cache_store
  end

  def fetch_all_units
    @cache.fetch(CACHE_KEY, expires_in: CACHE_EXPIRATION) do
      yield
    end
  end

  def expire
    @cache.delete(CACHE_KEY)
  end

  def clear_and_refetch
    expire
    fetch_all_units { Unit.all.to_a }
  end
end
