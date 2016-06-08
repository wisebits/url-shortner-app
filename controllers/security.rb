require 'sinatra'
require 'slim'
require 'rack/ssl-enforcer'
require 'secure_headers'

# Security settings for Url Shortner
class ShareConfigurationsApp < Sinatra::Base
  disable :protection  # required for Rack::Protection middleware below
  use Rack::Session::Cookie, secret: ENV['MSG_KEY'],
                             expire_after: 60 * 60 * 24 * 7

  configure :production do
    use Rack::SslEnforcer
  end

  # Against CSRF (requires `disable :protection` before `use Rack::Session::...`)
  use Rack::Protection, reaction: :drop_session
  use SecureHeaders::Middleware

  SecureHeaders::Configuration.default do |config|
    config.cookies = {
      secure: true,
      httponly: true,
      samesite: {
        strict: true
      }
    }

    config.x_frame_options = 'DENY'
    config.x_content_type_options = 'nosniff'
    config.x_xss_protection = '1'
    config.x_permitted_cross_domain_policies = 'none'
    config.referrer_policy = 'origin-when-cross-origin'

    config.csp = {
      report_only: false,
      preserve_schemes: true,
      default_src: %w('self'),
      child_src: %w('self'),
      connect_src: %w(wws:),
      img_src: %w('self'),
      font_src: %w('self' https://maxcdn.bootstrapcdn.com),
      script_src: %w('self' https://code.jquery.com https://maxcdn.bootstrapcdn.com),
      style_src: %w('self' 'unsafe-inline' https://maxcdn.bootstrapcdn.com https://cdnjs.cloudflare.com),
      form_action: %w('self'),
      frame_ancestors: %w('none'),
      plugin_types: %w('none'),
      block_all_mixed_content: true,
      upgrade_insecure_requests: true,
      report_uri: %w(/report_csp_violation)
    }
  end

  post '/report_csp_violation' do
    logger.info("CSP VIOLATION: #{request.body.read}")
  end
end