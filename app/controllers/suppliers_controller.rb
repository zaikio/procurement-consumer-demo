require "typhoeus/adapters/faraday"

class SuppliersController < DashboardController
  def index
    @suppliers = nil
    @upcoming = nil

    http_client.in_parallel do
      @suppliers = http_client.get("/api/v2/suppliers").body
      @upcoming = http_client.get("/api/v2/upcoming_suppliers").body
    end
  end

  def show
    @supplier = http_client.get("/api/v2/suppliers/#{params[:id]}").body
  end

  private

  def http_client
    Faraday.new("https://procurement.sandbox.zaikio.com/") do |conn|
      conn.adapter :typhoeus
      conn.headers["Authorization"] = "Bearer #{session[:token]}"
      conn.request :json
      conn.response :json
    end
  end
end
