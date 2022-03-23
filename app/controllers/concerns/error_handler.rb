# frozen_string_literal: true

module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :invalid
    rescue_from RuntimeError, with: :unprocessable_entity
  end

  private

  def unprocessable_entity(e)
    render json: { errors: [{ message: e }] }, status: :unprocessable_entity
  end

  def not_found(e)
    render json: { errors: [{ message: e }] }, status: :not_found
  end

  def invalid(e)
    render json: { errors: e.record.errors.full_messages.map do |message|
      { message: }
    end }, status: :unprocessable_entity
  end
end
