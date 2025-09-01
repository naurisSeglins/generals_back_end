RSpec.describe Unit, type: :model do
  describe "verify attributes" do
    context "when correct unit attributes" do
      let(:unit) { build_stubbed(:unit, position_y: -1.0) }

      it "matches the attributes" do
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
        expect { validating }.to(
          change { unit.errors[:position_y] }.to([ "entered value isn't a number" ])
        )
      end
    end
  end

  describe "callbacks" do
    context "#log_new_unit_creation (after_create_commit)", freeze_at: "2025-01-01 12:00" do
      subject(:callback_after_create_commit) { unit.save! }

      let(:unit) { build(:unit, name: "callbackUnit123") }

      let(:mock_logger) do
        instance_double(Logger, info: nil, debug: nil, "level=": nil, "formatter=": nil)
      end

      before do
        allow(Logger).to receive(:new) { mock_logger }
      end

      it "writes debug message to special log" do
        callback_after_create_commit

        expect_logger_to_have_been_initialized
        expect_logging_to_have_occurred
      end

      def expect_logger_to_have_been_initialized
        expect(Logger).to(
          have_received(:new).with(Rails.root.join("log/unit_creation.log").to_s).once,
        )
      end

      def expect_logging_to_have_occurred
        expect(mock_logger).to(
          have_received(:debug).with(
            %r{\ANew Unit#\d+ \'callbackUnit123\' created at 2025-01-01 12:00},
          ).once,
        )
      end
    end
  end
end
