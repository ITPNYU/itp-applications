require 'bundler'
Bundler.require
require 'bcrypt'

Dir["./src/*.rb"].each {|file| require file }
Dir["./src/*/*.rb"].each {|file| require file }

builder = Rack::Builder.new do
  use Rack::CommonLogger
  use Rack::ShowExceptions
  use Rack::Session::Cookie, key: 'itp-applications', secret: (ENV['SESSION_SECRET'] || "super secret")
  use Rack::MethodOverride
  use Rack::Flash, accessorize: [:error, :success]

  use OmniAuth::Builder do
    provider :saml,
      :assertion_consumer_service_url => ENV['SITE_DOMAIN'] + "/auth/saml/callback",
      :issuer                         => ENV['SAML_ISSUER'],
      :idp_sso_target_url             => "https://itp.nyu.edu/simplesaml/saml2/idp/SSOService.php",
      :idp_cert                       => ENV['IDP_CERT']
  end

  use Warden::Manager do |config|
    config.serialize_into_session{|user| user.id }
    config.serialize_from_session{|id| User.get(id) }
    config.scope_defaults :default,
      strategies: [:password],
      action: 'auth/unauthenticated'
    config.failure_app = self
  end

  Warden::Manager.before_failure do |env,opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:password) do
    def valid?
      params['user']
    end

    def authenticate!
      user = User.first(netid: params['user']['netid'])

      if user.nil?
        fail!("The username you entered does not exist.")
      elsif user.authenticate(params['user']['password'])
        success!(user)
      else
        fail!("Could not log in")
      end
    end
  end

  map ('/')                     { run Main }
  map ('/attachments')          { run AttachmentsApp }
  map ('/auth' )                { run AuthenticationManager }
  map ('/api')                  { run API }
  map ('/readings')             { run Readings }
  map ('/experiences')          { run Experiences }
  map ('/students')             { run Students }

  # Asset Pipeline
  map '/assets' do
    environment = Sprockets::Environment.new
    environment.append_path 'src/assets/javascripts'
    environment.append_path 'src/assets/stylesheets'
    environment.append_path HandlebarsAssets.path
    HandlebarsAssets::Config.template_namespace = 'JST'
    run environment
  end

end

run builder