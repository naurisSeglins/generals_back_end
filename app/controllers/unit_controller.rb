class UnitController < ApiController
  SCHEMA_PATH = Rails.root.join("config/schemas/unit.json")

  def index
    @units = Unit.all
    respond_with_resource({ units: @units }, :ok, "units", output_schema: SCHEMA_PATH)
  end

  def show
    @unit = Unit.find(params[:id])
    respond_with_resource @unit, :ok
  end

  def create
    errors = validate_json_schema(params[:unit], SCHEMA_PATH)
    return respond_with_errors(errors) if errors

    @unit = Unit.new(product_params)
    if @unit.save
      respond_with_resource @unit, :created
    else
      respond_with_errors(@unit.errors.full_messages)
    end
  end

  def update
  end

  def destroy
    @unit = Unit.find(params[:id]).destroy

    respond_with_resource @unit, :ok
  end

  private

  def product_params
    params.from_jsonapi.require(:unit).permit(
      :name, :position_x, :position_y
    )
  end
end
