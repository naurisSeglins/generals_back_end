class UnitController < ApiController
  SCHEMA_PATH = Rails.root.join("config/schemas/unit.json")

  def index
    @units = Rails.cache.fetch("all_units", expires_in: 12.hours) do
      Unit.all.to_a
    end
    respond_with_resource @units, :ok, "units", output_schema: SCHEMA_PATH
  end

  def show
    @unit = Unit.find(params[:id])
    respond_with_resource @unit, :ok, "unit", output_schema: SCHEMA_PATH
  end

  def create
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
    @unit = Unit.find(params[:id])

    if @unit.destroy
      head :no_content
    end
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
