class UnitController < ApiController
  validate_request_schema UnitSchema, :create, only: [ :create ]
  validate_request_schema UnitSchema, :update, only: [ :update ]

  def index
    @units = Unit.all
    respond_with_resource @units, :ok, serializer: ActiveModel::Serializer::CollectionSerializer,
                          each_serializer: UnitSerializer,
                          root: "units",
                          schema_class: UnitSchema,
                          schema_method: :collection
  end

  def show
    @unit = Unit.find(params[:id])
    respond_with_resource({ unit: @unit }, :ok, schema_class: UnitSchema, schema_method: :single)
  end

  def create
    @unit = Unit.new(product_params)

    if @unit.save
      respond_with_resource({ unit: @unit }, :created, schema_class: UnitSchema, schema_method: :single)
    end
  end

  def update
  end

  def destroy
    @unit = Unit.find(params[:id]).destroy

    respond_with_resource({ unit: @unit }, :ok, schema_class: UnitSchema, schema_method: :single)
  end

  private

  def product_params
    params.from_jsonapi.require(:unit).permit(
      :name, :position_x, :position_y
    )
  end
end
