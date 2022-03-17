class ApplicationController < ActionController::Base
  helper_method def logged_in?
    session[:token].present?
  end

  before_action do
    Rails.logger.info session.id
  end
end
