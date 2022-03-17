require "typhoeus/adapters/faraday"

class MaterialRequirementsController < DashboardController
  def create
    body = params
      .require(:material_requirement)
      .permit(:amount, :unit, :variant_id, sku_preference_ids: [])

    response = http_client.post(
      "/api/v2/material_requirements",
      JSON.dump(material_requirement: body.to_h),
      "Content-Type" => "application/json"
    )

    if response.success?
      redirect_to dashboard_material_requirement_path(id: response.body.fetch("id"))
    end
  end

  def index
    @material_requirements = http_client.get("/api/v2/material_requirements").body
  end

  def show
    @material_requirement = http_client.get("/api/v2/material_requirements/#{params[:id]}").body
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
