require 'sinatra'
require 'sinatra/activerecord'
require './db_class.rb'
require 'bcrypt'

enable :sessions

get '/' do 
  if session["user_id"].nil?
    redirect '/login'
  else
    @user = User.find(session["user_id"])
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

get './make_meeting' do # make function
    meeting = MeetingDetail.new
    meeting.starting_date = 3.days.from_now
    meeting.mid_date = 4.days.from_now
    meeting.meeting_date = 5.days.from_now
    meeting.location = "Seoul"
    meeting.cutline = 1
    meeting.save

    joined_user = JoinedUser.new
    joined_user.user_id = User.find(session["user_id"])
    joined_user.meeting_detail_id = params["meeting_detail_id"]
    joined_user.total_score = 0
    joined_user.ranking = 0
    joined_user.midranking = 0
    joined_user.is_deleted = false
    joined_user.save
end

post './main_page' do
    @user = User.find(session["user_id"])
    @meeting = MeetingDetail.last # TODO : Always meeting opend? check!!!
    erb :mainpage

    # TODO : Add function checking current time -> open/mid/end
    # view -> checking realtime.
    #         check mid ranking.
end

post './join_meeting' do 
    user = User.find(session["user_id"])
    meeting = MeetingDetail.find(params["meeting_detail_id"])
    # add user      
end

get './make_ranking' do # make function
    # calc ranking / cutline
end

get './use_heart' do # make function
    # calc ranking / heart / cutline

    erb :heartusing
end

get './matching' do
    # when last time calc ranking
    # udpate matched_history, meetingdetail
end

get './matched_success' do
    erb :matchingsuccess

    #view -> show matched people
end