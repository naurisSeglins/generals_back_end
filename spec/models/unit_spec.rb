require 'rails_helper'

RSpec.describe Unit, type: :model do
  describe "verify attributes" do
    context "when correct unit attributes" do
      let(:unit) { build_stubbed(:unit, position_y: -1.0) }

      it "matches the attributes" do
        puts unit

        expect(unit.name).to eql("sampleUnit1")
        expect(unit.position_x).to eql(1.0)
        expect(unit.position_y).to eql(-1.0)
      end
    end
  end

  describe "validations" do
    subject(:validating) { unit.valid? }

    context "when name have special characters and spaces" do
      # using "build_stubbed" instead of "build" because
      # testing format validations on string fields
      # (which don't undergo type conversion)
      # don't affect test result
      let(:unit) { build_stubbed(:unit, name: "unit1!!!") }
      it "returns validation error" do
        puts unit

        expect { validating }.to(
          change { unit.errors[:name] }.to([ "entered doesn't match allowed format" ])
        )
      end
    end

    context "when position isn't a number" do
      # using "build" instead of "build_stubbed" because
      # testing format validations on BigInt fields
      # (which do undergo type conversion)
      # affect test result since string is converted to 0
      let(:unit) { build(:unit, position_y: "aaa") }

      it "returns validation error" do
        puts unit
        expect { validating }.to(
          change { unit.errors[:position_y] }.to([ "entered value isn't a number" ])
        )
      end
    end
  end
end
