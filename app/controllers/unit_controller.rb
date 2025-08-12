class UnitController < ApiController
  def index
    @units = Unit.all
    respond_with_resource @units
  end

  def new
  end

  def show
  end

  def update
  end

  def destroy
  end
end
