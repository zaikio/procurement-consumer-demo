class DashboardController < ApplicationController
  before_action :check_logged_in

  def index
  end

  private

  def check_logged_in
    return current_organization if current_organization

    reset_session
    redirect_to(root_path)
  end

  helper_method def current_organization
    return if Time.at(session[:expiry]) < Time.zone.now

    session[:name].presence
  rescue
    nil
  end
end
