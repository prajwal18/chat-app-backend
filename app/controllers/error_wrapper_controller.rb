class ErrorWrapperController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  private

  def handle_invalid_record(e)
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end

  def handle_record_not_found(e)
    render json: { message: "User doesn't exist" }, status: :unauthorized
  end
end
