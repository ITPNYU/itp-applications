class Readings < Sinatra::Base
  register Sinatra::ThesisApp

  get '/' do
    @assignments = Assignment.all_active
    erb :'readings/index'
  end

  get '/:id' do
    @assignment = Assignment.get_active(params[:id])

    if @assignment.draft
      halt 404 unless env['warden'].user.admin?
    end

    erb :'readings/show'
  end

  # Edit page
  get '/:id/edit' do
    env['warden'].authenticate!
    halt 403 unless env['warden'].user.admin?

    erb :'readings/edit'
  end

  # Create route
  get '/new' do
    env['warden'].authenticate!
    halt 403 unless env['warden'].user.admin?

    erb :'readings/edit'
  end
end