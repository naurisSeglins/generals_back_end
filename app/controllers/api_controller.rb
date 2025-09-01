# frozen_string_literal: true

class ApiController < ApplicationController
  def respond_with_resource(resource, status)
    render json: resource, status: status
  end

  def respond_with_errors(errors, status: :unprocessable_entity)
    render json: { errors: errors }, status: status
  end
end
