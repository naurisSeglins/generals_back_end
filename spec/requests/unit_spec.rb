RSpec.describe "Units", type: :request do
  let(:headers) { { "Accept" => "application/json" } }

  describe "GET #index /unit" do
    subject(:make_request) { get path, headers: headers }

    let(:path) { "/unit" }

    context "when requesting all units" do
      let!(:unit_a) do
        Timecop.freeze("2025-01-02 11:00") do
          create(:unit, name: "unitA", position_x: 11.0, position_y: 10.0)
        end
      end
      let!(:unit_b) do
        Timecop.freeze("2025-01-03 10:00") do
          create(:unit, name: "unitB", position_x: 222.0, position_y: 101.0)
        end
      end
      let(:expected_response) do
        {
          data: [
            {
              id: unit_a.id.to_s,
              type: "unit",
              attributes: {
                name: "unitA",
                position_x: 11.0,
                position_y: 10.0,
                created_at: "2025-01-02T11:00:00Z",
                updated_at: "2025-01-02T11:00:00Z"
              }
            },
            {
              id: unit_b.id.to_s,
              type: "unit",
              attributes: {
                name: "unitB",
                position_x: 222.0,
                position_y: 101.0,
                created_at: "2025-01-03T10:00:00Z",
                updated_at: "2025-01-03T10:00:00Z"
              }
            }
          ]
        }
      end
      it "shows index" do
        make_request

        expect(response).to have_http_status(:ok)
        expect(response_json).to eq(expected_response)
      end
    end
    describe "GET #index with caching" do
      it "caches data to avoid database queries" do
        # Create a unit
        create(:unit, name: "unitA", position_x: 11.0, position_y: 10.0)

        # Before the first request, the cache should be empty
        expect(Rails.cache.exist?("all_units")).to be false

        # Make the first request
        get "/unit", headers: headers

        # First request should be 200 OK
        expect(response).to have_http_status(:ok)

        # After the first request, the cache should be populated
        expect(Rails.cache.exist?("all_units")).to be true

        # Let's directly check if the cache contains our unit
        cached_data = Rails.cache.read("all_units")
        expect(cached_data).to be_an(Array)
        expect(cached_data.first.name).to eq("unitA")

        # Now, let's stub the Unit.all method to track if it's called
        allow(Unit).to receive(:all).and_call_original

        # Make a second request
        get "/unit", headers: headers

        # Expect that Unit.all was not called during the second request
        expect(Unit).not_to have_received(:all)

        # The response should still be 200 with data
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("unitA")
      end

      it "returns fresh data when collection changes" do
        # Create first unit
        create(:unit, name: "unitA", position_x: 11.0, position_y: 10.0)

        # Make the first request
        get "/unit", headers: headers
        expect(response).to have_http_status(:ok)

        # Verify the cache was populated
        expect(Rails.cache.exist?("all_units")).to be true
        cached_data = Rails.cache.read("all_units")
        expect(cached_data.length).to eq(1)

        # Create another unit (collection has changed)
        create(:unit, name: "unitB", position_x: 22.0, position_y: 20.0)

        # Ensure cache was cleared by the after_create callback on Unit
        expect(Rails.cache.exist?("all_units")).to be false

        # Make the second request
        get "/unit", headers: headers

        # Verify the cache was repopulated with new data
        expect(Rails.cache.exist?("all_units")).to be true
        new_cached_data = Rails.cache.read("all_units")
        expect(new_cached_data.length).to eq(2)

        # Verify both units are in the response
        expect(response.body).to include("unitA")
        expect(response.body).to include("unitB")
      end

      it "returns fresh data when resource is updated" do
        # Create a unit
        unit = create(:unit, name: "unitA", position_x: 11.0, position_y: 10.0)

        # Make the first request
        get "/unit", headers: headers
        expect(response).to have_http_status(:ok)

        # Verify the cache was populated
        expect(Rails.cache.exist?("all_units")).to be true
        cached_data = Rails.cache.read("all_units")
        expect(cached_data.first.position_x).to eq(11.0)

        # Update the unit
        Timecop.travel(1.hour.from_now) do
          unit.update(position_x: 50.0)
        end

        # Ensure cache was cleared by the after_save callback on Unit
        expect(Rails.cache.exist?("all_units")).to be false

        # Make a second request
        get "/unit", headers: headers

        # Verify the cache was repopulated with updated data
        expect(Rails.cache.exist?("all_units")).to be true
        new_cached_data = Rails.cache.read("all_units")
        expect(new_cached_data.first.position_x).to eq(50.0)

        # Should be a fresh response with updated data
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("50.0")
      end
    end
  end

  describe "GET #show /unit/:id" do
    subject(:make_request) { get path, headers: headers }

    let(:path) { "/unit/#{unit.id}" }

    context "when requesting single unit" do
      let!(:unit) do
        Timecop.freeze("2025-02-03 12:00") do
          create(:unit, name: "unitX", position_x: 12.0, position_y: 120.0)
        end
      end
      let(:expected_response) do
        {
          data: {
            id: unit.id.to_s,
            type: "unit",
            attributes: {
              name: "unitX",
              position_x: 12.0,
              position_y: 120.0,
              created_at: "2025-02-03T12:00:00Z",
              updated_at: "2025-02-03T12:00:00Z"
            }
          }
        }
      end
      it "shows index" do
        make_request

        expect(response).to have_http_status(:ok)
        expect(response_json).to eq(expected_response)
      end
    end
  end

  describe "POST #create /unit" do
    subject(:make_request) { post path, headers: headers, params: params, as: :json }

    let(:path) { "/unit" }

    context "when requesting single unit creation with correct unit params" do
      let(:params) do
        {
          data: {
            type: "unit",
            attributes: {
              name: "unitZ",
              position_x: 111.0,
              position_y: 123.0
            }
          }
        }
      end

      let(:expected_response) do
        {
          data: {
            id: a_truthy_value,
            type: "unit",
            attributes: {
              name: "unitZ",
              position_x: 111.0,
              position_y: 123.0,
              created_at: a_truthy_value,
              updated_at: a_truthy_value
            }
          }
        }
      end
      it "creates a new unit and returns it's data" do
        expect { make_request }.to change { Unit.count }.by(1)

        expect(_created_unit = Unit.last).to have_attributes(
                                               name: "unitZ",
                                               position_x: 111.0,
                                               position_y: 123.0
                                             )

        expect(response).to have_http_status(:created)
        expect(response_json).to match(expected_response)
      end
    end
  end

  describe "PATCH #update /unit/:id" do
    subject(:make_request) { patch path, headers: headers, params: params, as: :json }

    let(:path) { "/unit/#{unit.id}" }

    context "when updating single unit" do
      let!(:unit) do
        Timecop.freeze("2025-02-03 12:00") do
          create(:unit, name: "unitX", position_x: 12.0, position_y: 120.0)
        end
      end

      let(:params) do
        {
          data: {
            type: "unit",
            attributes: {
              position_x: 111.0,
              position_y: 123.0
            }
          }
        }
      end

      let(:expected_response) do
        {
          data: {
            id: unit.id.to_s,
            type: "unit",
            attributes: {
              name: "unitX",
              position_x: 111.0,
              position_y: 123.0,
              created_at: "2025-02-03T12:00:00Z",
              updated_at: "2025-02-04T12:00:00Z"
            }
          }
        }
      end
      it "updates the unit parameters" do
        Timecop.freeze("2025-02-04 12:00") do
          make_request
        end

        expect(response).to have_http_status(:ok)
        expect(response_json).to match(expected_response)
      end
    end
  end

  describe "DELETE #destroy /unit/:id" do
    subject(:make_request) { delete path, headers: headers }

    let(:path) { "/unit/#{unit.id}" }

    let!(:unit) { create(:unit) }

    context "making a request with correct params for unit deletion" do
      it "deletes the record and responds with no content" do
        expect { make_request }.to change { Unit.count }.by(-1)

        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
