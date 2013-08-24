class Students < Sinatra::Base
  register WillPaginate::Sinatra
  register Sinatra::BaseApp

  def authenticate
    env['warden'].authenticate!
    @current_user = env['warden'].user
  end

  get '/' do
    authenticate
    @students = User.students
    erb :'students/index'
  end

  #############################################################################
  #
  # POSTS
  #
  #############################################################################

  get '/:netid/:id/?' do
    @current_user = env['warden'].user

    # Get the post with only the necessary fields.
    @post = Post.first(id: params[:id], active: true)

    # Redirect if the post is a draft
    if @post.nil? || (@current_user.nil? && !@post.is_public) || (@post.draft && @post.user_id != @current_user.id )
      flash.error = "Sorry, that post is not viewable."
      redirect "/"
    elsif !@post.is_public && !env['warden'].authenticated?
      env['warden'].authenticate!
    else
      @current_user = env['warden'].user
      erb :'students/posts_show'
    end
  end

  get '/:netid/:id/edit/?' do
    check_user(params[:netid])
    redirect "/posts/#{params[:id]}/edit"
  end

  get '/:netid/:id/delete' do
    authenticate
    check_user(params[:netid])

    Post.first(id: params[:id]).delete

    redirect "/students/#{params[:netid]}"
  end

  #############################################################################
  #
  # PROFILE PAGE
  #
  #############################################################################

# @posts = Post.published.paginate(page: 1, user: @user)
# @posts = Post.published.paginate(page: params[:page_number], user: @user)

  get '/:netid/?' do
    @user = User.first(netid: params[:netid])
    @current_user = env['warden'].user

    halt 404 if @user.nil?

    erb :'students/show'
  end
end