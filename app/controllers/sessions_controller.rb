class SessionsController < ApplicationController
  def login
    if session[:token].present?
      redirect_to dashboard_path
    end
  end

  def callback
    oauth_data = request.env["omniauth.auth"]
    credentials = oauth_data.fetch("credentials")

    reset_session

    token = credentials.fetch("token")
    jwt = JWT.decode(token, nil, false)[0]
    scopes = jwt.fetch("scope", [])

    if scopes.any? { |s| s.include?("procurement_consumer") }
      session[:name], session[:logo_url] = get_hub_identity(token)
      session[:token] = token
      session[:expiry] = jwt["exp"]

      redirect_to dashboard_path
    else
      redirect_to root_path, alert: "Invalid scopes, please ensure you are connected to Procurement first then try again"
    end
  end

  def logout
    reset_session
    redirect_to root_path
  end

  private

  def get_hub_identity(token)
    connection = Faraday.new("https://hub.sandbox.zaikio.com") do |f|
      f.response :json
      f.headers["Authorization"] = "Bearer #{token}"
    end

    connection.get("/api/v1/organization").body.values_at("name", "logo_url")
  end
end
