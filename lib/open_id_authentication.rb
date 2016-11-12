require "open_id_authentication/version"
require "open_id_authentication/middleware"
require "open_id_authentication/controller_methods"
require "open_id_authentication/railtie" if defined?(::Rails::Railtie)

module OpenIdAuthentication
  # deprecated middleware creation
  def self.new(*args)
    raise "Use OpenIdAuthentication::Middleware"
  end

  def self.store
    Middleware.store
  end

  def self.store=(*args)
    Middleware.store = *args
  end

  # normalizes an OpenID according to http://openid.net/specs/openid-authentication-2_0.html#normalization
  def self.normalize_identifier(identifier)
    # clean up whitespace
    identifier = identifier.to_s.strip

    # if an XRI has a prefix, strip it.
    identifier.gsub!(/xri:\/\//i, '')

    # dodge XRIs -- TODO: validate, don't just skip.
    unless ['=', '@', '+', '$', '!', '('].include?(identifier.at(0))
      # does it begin with http? if not, add it.
      identifier = "http://#{identifier}" unless identifier =~ /^http/i

      # strip any fragments
      identifier.gsub!(/\#(.*)$/, '')

      begin
        uri = URI.parse(identifier)
        uri.scheme = uri.scheme.downcase # URI should do this
        identifier = uri.normalize.to_s
      rescue URI::InvalidURIError
        raise InvalidOpenId.new("#{identifier} is not an OpenID identifier")
      end
    end

    return identifier
  end

  # deprecated for OpenID 2.0, where not all OpenIDs are URLs
  def self.normalize_url(url)
    ActiveSupport::Deprecation.warn "normalize_identifier has been deprecated, use normalize instead"
    self.normalize_identifier(url)
  end

  protected
    def normalize_url(url)
      OpenIdAuthentication.normalize_identifier(url)
    end
end
