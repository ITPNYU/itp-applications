class Experiences < Sinatra::Base
  register Sinatra::BaseApp

  get '/' do
    @posts = Post.all(:coords.not => nil)
    erb :'experiences/index', layout: :layout_experiences
  end

  get '/:id' do
  end

  get '/new' do
  end
end