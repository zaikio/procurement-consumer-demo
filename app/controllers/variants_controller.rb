require "typhoeus/adapters/faraday"

class VariantsController < DashboardController
  def index
  end

  def show
    @variant = http_client.get("/api/v2/variants/#{params[:id]}").body
  end

  def search
    @query = params[:query].presence
    @filters = (params[:filters]&.to_unsafe_hash || {}).compact_blank

    response = http_client.get(
      "/api/v2/variants",
      type: "all",
      query: @query || "*",
      filters: @filters,
      per_page: 25
    )

    @variants = response.body.fetch("results")
    @available_filters = response.body.fetch("available_filters")
    @pages = response.headers.slice("Total-Count", "Total-Pages", "Current-Page")

    respond_to do |f|
      f.html { render partial: "search" }
      f.turbo_stream { render turbo_stream: turbo_stream.replace(:variants, partial: "search") }
    end
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
