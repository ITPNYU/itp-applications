class Main < Sinatra::Base
  register WillPaginate::Sinatra
  register Sinatra::BaseApp

  # Load up Redis to cache list of users. This will make
  # matching top level paths such as "/:netid" faster than querying the db.
  uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379")
  redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

  # Flush the redis info.
  redis.del('itpapplications:users')
  # Add all students to Redis
  # User.students.each {|s| redis.sadd('itpapplications:users', s.netid) }

  # Set up this controller to handle all static files since this controller is
  # mapped to the root url.
  set :static, true
  set :public_folder, Proc.new { File.join(File.dirname(__FILE__), "../../public") }

  get '/' do
    # If someone is signed in, call the /dashboard route
    if env['warden'].authenticated?
      status, headers, body = call env.merge("PATH_INFO" => '/dashboard')
      [status, headers, body]
    # Otherwise, send the static welcome page.
    else
      "welcome"
    end
  end

  # Dashboard page. Create a dashboard to match all user roles.
  get '/dashboard' do
    env['warden'].authenticate!
    @current_user = env['warden'].user

    if @current_user.student?
      erb :'dashboards/student'
    elsif @current_user.admin?
      erb :'dashboards/advisor'
    else
      erb :'dashboards/provisional'
    end
  end

  # Check top level against student netids, redirect to student page if there
  # is a match, otherwise pass to next route.
  get '/:netid' do
    if redis.sismember('itpapplications:users', params[:netid])
      redirect "/students/#{params[:netid]}"
    else
      pass
    end
  end
end