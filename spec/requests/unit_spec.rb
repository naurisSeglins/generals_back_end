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
                created_at: "2025-01-02T11:00:00.000Z",
                updated_at: "2025-01-02T11:00:00.000Z"
              }
            },
            {
              id: unit_b.id.to_s,
              type: "unit",
              attributes: {
                name: "unitB",
                position_x: 222.0,
                position_y: 101.0,
                created_at: "2025-01-03T10:00:00.000Z",
                updated_at: "2025-01-03T10:00:00.000Z"
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
              created_at: "2025-02-03T12:00:00.000Z",
              updated_at: "2025-02-03T12:00:00.000Z"
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
end
