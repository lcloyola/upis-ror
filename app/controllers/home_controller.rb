class HomeController < ApplicationController
  include ApplicationHelper
  def index
    @requests = Course.pending_requests if is_admin?
  end
end

