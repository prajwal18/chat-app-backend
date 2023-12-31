class ErrorWrapperController < ApplicationController
  include ErrorWrapperHelper

  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
end
