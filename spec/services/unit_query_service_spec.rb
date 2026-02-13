# frozen_string_literal: true



RSpec.describe UnitQueryService do
  let(:cache_service) { instance_double(UnitCacheService) }
  let(:service) { described_class.new(cache_service: cache_service) }

  describe "#all" do
    let(:units) { [create(:unit), create(:unit)] }

    it "delegates to cache service" do
      expect(cache_service).to receive(:fetch_all_units).and_yield.and_return(units)
      allow(Unit).to receive(:all).and_return(double(to_a: units))

      result = service.all

      expect(result).to eq(units)
    end
  end

  describe "#find" do
    let(:unit) { create(:unit) }

    it "finds unit by id" do
      result = service.find(unit.id)

      expect(result).to eq(unit)
    end

    it "raises error when unit not found" do
      expect {
        service.find(999_999)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
