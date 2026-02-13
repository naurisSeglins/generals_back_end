# frozen_string_literal: true



RSpec.describe UnitObserver do
  let(:cache_service) { instance_double(UnitCacheService) }
  let(:logger_service) { instance_double(UnitLoggerService) }
  let(:observer) do
    described_class.new(
      cache_service: cache_service,
      logger_service: logger_service
    )
  end
  let(:unit) { create(:unit) }

  describe "#after_create" do
    it "logs unit creation" do
      expect(logger_service).to receive(:log_creation).with(unit)

      observer.after_create(unit)
    end
  end

  describe "#after_save" do
    it "expires cache" do
      expect(cache_service).to receive(:expire)

      observer.after_save(unit)
    end
  end

  describe "#after_destroy" do
    it "expires cache" do
      expect(cache_service).to receive(:expire)

      observer.after_destroy(unit)
    end
  end
end
