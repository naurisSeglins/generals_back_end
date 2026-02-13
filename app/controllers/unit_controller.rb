# frozen_string_literal: true

class UnitController < ApiController
  SCHEMA_PATH = Rails.root.join("config/schemas/unit.json")

  def initialize
    super
    @query_service = UnitQueryService.new
    @command_service = UnitCommandService.new
  end

  def index
    units = @query_service.all
    respond_with_resource units, :ok, "units", output_schema: SCHEMA_PATH
  end

  def show
    unit = @query_service.find(params[:id])
    respond_with_resource unit, :ok, "unit", output_schema: SCHEMA_PATH
  end

  def create
    unit = @command_service.create(unit_params)
    respond_with_resource unit, :created, "unit", output_schema: SCHEMA_PATH
  rescue UnitCommandService::CreationError => e
    respond_with_errors([e.message])
  end

  def update
    unit = @command_service.update(params[:id], position_params)
    respond_with_resource unit, :ok, "unit", output_schema: SCHEMA_PATH
  rescue UnitCommandService::UpdateError => e
    respond_with_errors([e.message])
  end

  def destroy
    @command_service.destroy(params[:id])
    head :no_content
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
