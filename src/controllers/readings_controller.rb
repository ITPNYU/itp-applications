class Readings < Sinatra::Base
  register Sinatra::BaseApp

  get '/' do
    @collection = Assignment.all_active
    erb :'readings/index'
  end

  # Create route
  get '/new' do
    env['warden'].authenticate!
    halt 403 unless env['warden'].user.admin?

    @model = Assignment.new

    erb :'readings/edit'
  end

  get '/:id' do
    @model = Assignment.get_active(params[:id])
    @collection = Assignment.all_active

    if @model.draft
      halt 404 unless env['warden'].user.admin?
    end

    erb :'readings/index'
  end

  # Edit page
  get '/:id/edit' do
    env['warden'].authenticate!
    halt 403 unless env['warden'].user.admin?

    @model = Assignment.get_active(params[:id])

    erb :'readings/edit'
  end
end