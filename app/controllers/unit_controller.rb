class UnitController < ApiController
  def index
    @units = Unit.all
    respond_with_resource @units, :ok
  end

  def show
    @unit = Unit.find(params[:id])
    respond_with_resource @unit, :ok
  end

  def create
    @unit = Unit.new(product_params)

    if @unit.save
      respond_with_resource @unit, :created
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
