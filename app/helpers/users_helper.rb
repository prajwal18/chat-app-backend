module UsersHelper

  def find_user_from_email(email)
    user = User.where(email:).first
    return user unless user.nil?

    raise ActiveRecord::RecordNotFound
  end

  class Helper
    extend UsersHelper
  end
end
