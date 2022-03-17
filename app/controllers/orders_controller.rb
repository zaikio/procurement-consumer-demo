require "typhoeus/adapters/faraday"

class OrdersController < DashboardController
  def create
    body = params
      .require(:order)
      .permit(material_requirement_ids: [])

    response = http_client.post(
      "/api/v2/orders",
      JSON.dump(order: body.to_h),
      "Content-Type" => "application/json"
    )

    if response.success?
      redirect_to dashboard_order_path(id: response.body.fetch("id"))
    end
  end

  def index
    @orders = http_client.get("/api/v2/orders").body
  end

  def show
    @order = http_client.get("/api/v2/orders/#{params[:id]}").body
  end

  private

  def http_client
    Faraday.new("https://procurement.sandbox.zaikio.com/") do |conn|
      conn.adapter :typhoeus
      conn.headers["Authorization"] = "Bearer #{session[:token]}"
      conn.request :url_encoded
      conn.response :json
    end
  end
end
