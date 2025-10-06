# Allows `freeze_at: "2024-05-20 12:00"` metadata use to freeze time.
RSpec.configure do |config|
  config.around do |example|
    freeze_time = example.metadata[:freeze_at]

    if freeze_time
      Timecop.freeze(freeze_time) do
        example.run
      end
    else
      example.run
    end
  end
end
