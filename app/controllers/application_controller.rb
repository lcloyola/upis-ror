class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
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
end

