require "omniauth-oauth2"

HUB_URL = "https://hub.sandbox.zaikio.com"

module OmniAuth
  module Strategies
    class Zaikio < OmniAuth::Strategies::OAuth2
      option :name, "zaikio"

      option :client_options, site: HUB_URL,
                              token_url: "oauth/access_token",
                              auth_scheme: :request_body,
                              connection_opts: { headers: { Accept: "application/json" } }
    end
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :zaikio,
           ENV.fetch("ZAIKIO_CLIENT_ID"),
           ENV.fetch("ZAIKIO_CLIENT_SECRET"),
           scope: %w(
             Org.directory.organization.r
             Org.procurement_consumer.article_base.r
             Org.procurement_consumer.contracts.rw
             Org.procurement_consumer.material_requirements.rw
             Org.procurement_consumer.orders.rw
           ).join(",")
end

ZAIKIO_PUBLIC_JWKS = ->(options) do
  connection = Faraday.new(URI.join(HUB_URL, "/api/v1/jwt_public_keys")) do |f|
    f.response :json
  end

  connection.get.body.deep_symbolize_keys!
end
