class AdminApp < Sinatra::Base
  register Sinatra::BaseApp

  before do
    env['warden'].authenticate!
    @current_user = env['warden'].user
  end

  get '/' do
    "admin"
  end
end