class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :user_active!
  layout :choose_layout

  def choose_layout
    if !user_signed_in?
      "application"
    elsif current_user.role == Role::Admin
      "application"
    elsif current_user.role == Role::Faculty
      "faculty"
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
end

