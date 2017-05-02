Rails.application.config.middleware.use OmniAuth::Builder do
  provider :ncu_portal_open_id, {provider_ignores_state: true}
end
