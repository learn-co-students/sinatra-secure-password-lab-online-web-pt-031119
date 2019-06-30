require "./config/environment"
require "./app/models/user"
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    #if username or password is blank, redirect to failure erb, else refirct to login erb.  
  if params[:username] == "" || params[:password] == ""
      redirect '/failure'
    else
      User.create(username: params[:username], password: params[:password])
      redirect '/login'
    end

  end

  get '/account' do
    
  @user = User.find(session[:user_id])
    erb :account
    
  end


  get "/login" do
    erb :login
  end

  post "/login" do
    #search DB for username 
    @user = User.find_by(username: params[:username])
     
    #verify username and password match, if match set as session id and redirect to account erb, else redirect to failure erb.
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/account"
    else
      redirect "/failure"
    end
  end
  
  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end

