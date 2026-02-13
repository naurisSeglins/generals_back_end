# frozen_string_literal: true



RSpec.describe UnitCommandService do
  let(:service) { described_class.new }

  describe "#create" do
    let(:valid_params) { { name: "Soldier", position_x: 100, position_y: 200 } }

    it "creates a unit with valid params" do
      expect {
        service.create(valid_params)
      }.to change(Unit, :count).by(1)
    end

    it "returns the created unit" do
      unit = service.create(valid_params)

      expect(unit).to be_a(Unit)
      expect(unit.name).to eq("Soldier")
    end

    it "raises CreationError with invalid params" do
      invalid_params = { name: "AB" } # Too short

      expect {
        service.create(invalid_params)
      }.to raise_error(UnitCommandService::CreationError)
    end

    it "includes error messages in exception" do
      invalid_params = { name: "AB" }

      begin
        service.create(invalid_params)
      rescue UnitCommandService::CreationError => e
        expect(e.message).to include("too short")
      end
    end
  end

  describe "#update" do
    let(:unit) { create(:unit) }
    let(:valid_params) { { position_x: 300, position_y: 400 } }

    it "updates the unit" do
      updated_unit = service.update(unit.id, valid_params)

      expect(updated_unit.position_x).to eq(300)
      expect(updated_unit.position_y).to eq(400)
    end

    it "raises UpdateError with invalid params" do
      invalid_params = { position_x: "not_a_number" }

      expect {
        service.update(unit.id, invalid_params)
      }.to raise_error(UnitCommandService::UpdateError)
    end

    it "raises error when unit not found" do
      expect {
        service.update(999_999, valid_params)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#destroy" do
    let!(:unit) { create(:unit) }

    it "destroys the unit" do
      expect {
        service.destroy(unit.id)
      }.to change(Unit, :count).by(-1)
    end

    it "returns the destroyed unit" do
      result = service.destroy(unit.id)

      expect(result).to be_destroyed
    end

    it "raises error when unit not found" do
      expect {
        service.destroy(999_999)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
