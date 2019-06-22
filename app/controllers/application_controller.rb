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
    if params[:username] != "" && params[:password] != ""
      user = User.create(username: params[:username], password: params[:password], balance: 0)
      if user
        redirect '/login'
      end
    else
      redirect '/failure'
    end
  end

  get '/account' do
    @user = User.find_by(id: session[:user_id]) 
    # if logged_in?
    erb :account 
    # end 
    # erb :failure
  end

  post '/account' do
    @user = User.find_by(id: session[:user_id])
    binding.pry
    if params[:deposit] && deposit_valid?
      @user.balance += (params[:deposit].to_f)
    elsif params[:withdrawal] && withdrawal_valid?
      @user.balance -= (params[:withdrawal].to_f)
    end
    redirect '/account'
  end

  get "/login" do
    erb :login
  end

  post "/login" do
    if params[:username] != "" && params[:password] != ""
      @user = User.find_by(username: params[:username]) 
      #binding.pry
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect '/account'
      end
    else
      redirect '/failure'
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

    def deposit_valid?
      !!(params[:deposit].to_f > 0)
    end

    def withdrawal_valid?
      !!(params[:withdrawal].to_f <= current_user.balance)
    end
  end

end
