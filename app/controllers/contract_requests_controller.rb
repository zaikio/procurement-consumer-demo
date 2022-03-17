require "typhoeus/adapters/faraday"

class ContractRequestsController < DashboardController
  def new
  end

  def create
    opts = contract_request_params
    url = "/api/v2/suppliers/#{opts.delete(:supplier_id)}/contract_requests"

    Rails.logger.info "Posting: #{JSON.dump(contract_request: opts.to_h.compact_blank)}"

    response = http_client.post(url, JSON.dump(contract_request: opts.to_h.compact_blank), "Content-Type" => "application/json")

    if response.success?
      redirect_to dashboard_suppliers_path, notice: "Yay!"
    else
      @errors = response.body
      render :new, status: :unprocessable_entity
    end
  end

  private

  def contract_request_params
    params.require(:contract_request).permit(
      :supplier_id,
      :customer_number,
      :contact_first_name,
      :contact_last_name,
      :contact_email,
      :contact_phone
    )
  end

  def http_client
    Faraday.new("https://procurement.sandbox.zaikio.com/") do |conn|
      conn.headers["Authorization"] = "Bearer #{session[:token]}"
      conn.request :json
      conn.response :json
      conn.response :logger
    end
  end
end
