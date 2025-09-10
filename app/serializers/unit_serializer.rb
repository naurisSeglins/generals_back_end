# frozen_string_literal: true

class UnitSerializer < ActiveModel::Serializer
  attributes :id, :name, :position_x, :position_y, :created_at, :modified_at
end
