# frozen_string_literal: true

class UnitSerializer < ActiveModel::Serializer
  attributes :id, :name, :position_x, :position_y, :created_at, :updated_at

  def position_x
    object.position_x.to_f
  end

  def position_y
    object.position_y.to_f
  end
end
