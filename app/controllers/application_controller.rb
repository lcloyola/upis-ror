class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :user_active!
  layout :choose_layout
  RESTRICTED_NOTICE = "<div class='alert alert-error'>Restricted access.</div>"

  def choose_layout
    if !user_signed_in?
      "application"
    elsif current_user.role == Role::Admin
      "application"
    else
      "user"
    end
  end

  def user_active!
    if user_signed_in? && !current_user.is_active?
      sign_out(current_user)
      redirect_to root_url
      return false
    end
    return true
  end

  def allow_access!(x)
    return true if (current_user.role == Role::Admin) and x >= 8
    return true if (current_user.role == Role::Faculty) and x.odd?
    return true if (current_user.role == Role::Moderator) and ((4..7).include?(x) or (11..15).include?(x))
    return true if (current_user.role == Role::RecordStaff) and ([2,3,6,7,10,11,13,14,15].include?(x))
    redirect_to root_url, notice: RESTRICTED_NOTICE
    return false
  end
end

