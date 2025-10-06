# frozen_string_literal: true

class UnitSerializer < ActiveModel::Serializer
  # attributes :id, :name, :position_x, :position_y, :created_at, :updated_at
  attributes :name, :position_x, :position_y, :created_at, :updated_at

  # type field for JSON:API format
  def type
    "unit"
  end

  def position_x
    object.position_x.to_f
  end

  def position_y
    object.position_y.to_f
  end

  def created_at
    object.created_at.iso8601
  end

  def updated_at
    object.updated_at.iso8601
  end
end
