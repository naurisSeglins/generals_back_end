# frozen_string_literal: true



RSpec.describe UnitCacheService do
  let(:cache_store) { ActiveSupport::Cache::MemoryStore.new }
  let(:service) { described_class.new(cache_store) }

  describe "#fetch_all_units" do
    it "caches the result of the block" do
      result = service.fetch_all_units { ["unit1", "unit2"] }

      expect(result).to eq(["unit1", "unit2"])
    end

    it "returns cached value on subsequent calls" do
      call_count = 0

      2.times do
        service.fetch_all_units do
          call_count += 1
          ["units"]
        end
      end

      expect(call_count).to eq(1)
    end

    it "uses the correct cache key" do
      service.fetch_all_units { ["units"] }

      expect(cache_store.exist?("all_units")).to be true
    end
  end

  describe "#expire" do
    it "removes the cached value" do
      service.fetch_all_units { ["units"] }

      service.expire

      expect(cache_store.exist?("all_units")).to be false
    end
  end

  describe "#clear_and_refetch" do
    before do
      allow(Unit).to receive(:all).and_return(double(to_a: ["new_units"]))
    end

    it "expires cache and fetches fresh data" do
      service.fetch_all_units { ["old_units"] }

      result = service.clear_and_refetch

      expect(result).to eq(["new_units"])
    end
  end
end
