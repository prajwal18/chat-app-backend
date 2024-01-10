module ErrorWrapperHelper
  def handle_invalid_record(error)
    render json: { errors: error.record.errors.full_messages }, status: :unprocessable_entity
  end

  def handle_record_not_found(_error)
    render json: { message: "User doesn't exist" }, status: :unauthorized
  end

  def handle_invalid_argument(error)
    render json: { message: error }, status: :unauthorized
  end
end
