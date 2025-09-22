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
          units: [
            {
              id: unit_a.id.to_s,
              name: "unitA",
              position_x: 11.0,
              position_y: 10.0,
              created_at: "2025-01-02T11:00+00:00",
              updated_at: "2025-01-02T11:00+00:00"
            },
            {
              id: unit_b.id.to_s,
              name: "unitB",
              position_x: 222.0,
              position_y: 101.0,
              created_at: "2025-01-03T11:00+00:00",
              updated_at: "2025-01-03T11:00+00:00"
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
end
