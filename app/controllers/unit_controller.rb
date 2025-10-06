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
    puts "do we even call this method?"
    @unit = Unit.new(unit_params)
    puts "are we even here?"
    if @unit.save
      puts "did we save?"
      respond_with_resource @unit, :created, "unit", output_schema: SCHEMA_PATH
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

  def unit_params
    puts "do we get till here?"
    puts "params: #{params}"
    puts "params from json: #{params.from_jsonapi}"
    puts "params require: #{params.from_jsonapi.require(:unit)}"
    params.from_jsonapi.require(:unit).permit(
      :name, :position_x, :position_y
    )
  end
end
