class UnitController < ApiController
  SCHEMA_PATH = Rails.root.join("config/schemas/unit.json")

  def index
    @units = Unit.all
    respond_with_resource @units, :ok, "units", output_schema: SCHEMA_PATH
  end

  def show
    @unit = Unit.find(params[:id])
    respond_with_resource @unit, :ok, "unit", output_schema: SCHEMA_PATH
  end

  def create
    # errors = validate_json_schema(params[:unit], SCHEMA_PATH)
    # return respond_with_errors(errors) if errors
    @unit = Unit.new(unit_params)
    if @unit.save
      respond_with_resource @unit, :created, "unit", output_schema: SCHEMA_PATH
    else
      respond_with_errors(@unit.errors.full_messages)
    end
  end

  def update
    @unit = Unit.find(params[:id])
    if @unit.update(position_params)
      respond_with_resource @unit, :ok, "unit", output_schema: SCHEMA_PATH
    end
  end

  def destroy
    @unit = Unit.find(params[:id]).destroy

    respond_with_resource @unit, :ok
  end

  private

  def unit_params
    params.from_jsonapi.require(:unit).permit(
      :name, :position_x, :position_y
    )
  end

  def position_params
    params.from_jsonapi.require(:unit).permit(:position_x, :position_y)
  end
end
