require 'sinatra'
# require 'sinatra/activerecord'
require './db_class.rb'
require 'bcrypt'

enable :sessions

get '/' do 
  if session["user_id"].nil?
    redirect '/login'
  else
    @user = User.find(session["user_id"])
    # find(#integer) like hash
    # user id exist only, in session
    erb :initpage
  end
end

get '/login' do
  erb :login
end

get '/signup' do 
  erb :signup
end

get '/logout' do 
  session.clear
  redirect '/'
end

post '/login_process' do 
    user = User.where("email" => params["email"]).first
    if !user.nil? and user.password == params["password"] 
        session["user_id"] = user.id
    end
        redirect "/"
end

post '/signup_process' do 
    if params["password"] != params["password_confirm"]
        redirect back
    else
        user = User.new

        user.company_id = 1
        user.current_heart = 0
        user.nickname = params["nickname"]
        user.email = params["email"]
        user.password = params["password"]
        user.phone_number = params["phone_number"]
        user.location = params["location"]
        # user.profile_img = params["profile_img"]
        user.profile_img = "image_src_location"
        user.team_detail = params["team_detail"]
        user.recommendation_code = params["recommendation_code"]
        if params["gender"] == "male"
            user.is_male = true
        else
            user.is_male = false
        end
        user.save

        session["user_id"] = user.id
        redirect '/'
    end
end
