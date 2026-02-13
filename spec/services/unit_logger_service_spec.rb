# frozen_string_literal: true



RSpec.describe UnitLoggerService do
  let(:logger) { instance_double(Logger) }
  let(:service) { described_class.new(logger) }
  let(:unit) { create(:unit, id: 123, name: "TestUnit") }

  describe "#log_creation" do
    it "logs unit creation with correct format" do
      expect(logger).to receive(:debug).with(
        /New Unit#123 'TestUnit' created at/
      )

      service.log_creation(unit)
    end

    it "includes unit id in log message" do
      allow(logger).to receive(:debug) do |message|
        expect(message).to include("Unit#123")
      end

      service.log_creation(unit)
    end

    it "includes unit name in log message" do
      allow(logger).to receive(:debug) do |message|
        expect(message).to include("TestUnit")
      end

      service.log_creation(unit)
    end
  end
end
