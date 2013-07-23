class API < Sinatra::Base
  register Sinatra::BaseApp
  register WillPaginate::Sinatra

  before do
    env['warden'].authenticate!
    @current_user = env['warden'].user
    content_type :json
  end

  #################################################
  #                                               #
  #          POSTS                                #
  #                                               #
  #################################################

  post '/posts/?' do
    post_params = JSON.parse(request.body.read)
    post_params['user_id'] = env['warden'].user.id

    @post = Post.new(post_params)

    if @post.save
      @post.to_json
    else
      halt 500
    end
  end

  put '/posts/:id' do
    post_params = JSON.parse(request.body.read)

    @post = Post.get(params[:id])
    check_user(@post.user.netid)

    @post.update({
      title: post_params['title'],
      content: post_params['content'],
      draft: post_params['draft'],
      category_id: post_params['category_id'],
      assignment_id: post_params['assignment_id']
    })

    @post.to_json
  end

  # Assignments
  #
  # CRUD interface for Assignments, aliased as "Readings"

  # index
  get '/assignments' do
    @assignments = Assignment.all(year: viewing_year)

    @assignments.to_json
  end

  # view
  get '/assignments/:id' do
    @assignment = Assignment.get_active(params[:id])

    if @assignment.draft
      halt 404 unless env['warden'].user.admin?
    end

    @assignment.to_json
  end

  # associated posts
  get '/assignments/:id/posts' do
    @assignment = Assignment.get_active(params[:id])

    if @assignment.draft
      halt 404 unless env['warden'].user.admin?
    end

    @assignment.posts.to_json
  end

  # create
  post '/assignments' do
    env['warden'].authenticate!
    halt 403 unless env['warden'].user.admin?

    @assignment = Assignment.new(JSON.parse(request.body.read))

    if @assignment.save
      @assignment.to_json
    else
      halt 500
    end
  end

  # edit
  put '/assignments/:id' do
    env['warden'].authenticate!
    halt 403 unless env['warden'].user.admin?

    @assignment = Assignment.get_active(params[:id])
    @assignment.update(JSON.parse(request.body.read))

    @assignment.to_json
  end

  # 'delete'
  delete '/assignments/:id' do
    env['warden'].authenticate!
    halt 403 unless env['warden'].user.admin?

    @assignment = Assignment.get_active(params[:id])
    @assignment.delete

    {status: 'OK', message: 'Assignment deleted'}.to_json
  end
end