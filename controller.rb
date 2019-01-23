require 'sinatra'
require 'bcrypt'
require './db_class.rb'
# require './function.rb'
# require './seeds.rb'

###################################################################################################

# <NOTICE>: 'check session' is a justifed function!

# [Function]
# : check_session, get_meeting_info, join, assign_first_score, get_ranking_result, get_cutline, use_heart, use_cash

# [Controller]
# : POST - login_process, sign_up_process, edit_my_info_process, invite, find_lost_password
# : GET - login, sign_up, heart_payment, cash_payment, logout, secession, get_matching_result, get_my_info

# and..... please think more
###################################################################################################

get '/' do 
    if !session["user_id"].nil?
        redirect '/main'
    else
        erb :initpage
    end
end

get '/main' do
    if session["user_id"].nil?
        redirect '/'
    else
    puts "main"
    # erb :main
    end
end
  
get '/get_matching_result' do
    if session["user_id"].nil?
        redirect '/'
    else
    puts "matching result"
    # erb :matching_result
    end
end

get '/delete/:user_id' do 
    user = User.find(session["user_id"])
    user.delete
    redirect '/'
  end
  
post '/logout' do
    session.clear
    redirect '/'
end

#post '/profile' do
    #end
    

post '/buy_heart' do
end

post '/chats' do
end

# post '/secession' do
#     check session
#     if BCrypt::Password.new(user.password) != params["password"] # I don't know it exactly..
#         redirect '/error_3'
#     else
#         user.delete
#         redirect '/'
#     end
# end
  

# post '/login_process' do
#     user = User.find_by_email(params["email"])

#     if user.nil?
#         redirect '/error_2_1'
#     end
    
#     if BCrypt::Password.new(user.password) != params["password"] # I don't know it exactly..
#         redirect '/error_2_2'
#     end

#     session["user_id"] = user.id
#     redirect "/"
# end

# get '/cash_payment' do 
#     check session
#     user.cash_payments 
#     redirect '/'
# end

# get '/get_heart_payment' do 
#     check session
#     user.cash_payments
#     redirect '/'
# end

# post '/sign_up_process' do
#     if params["nickame"].nil?
#         redirect '/error1_1'

#     elsif params["password"].nil?
#         redirect '/error1_2'

#     elsif params["password_confirm"].nil?
#         redirect '/error1_3'
        
#     elsif params["email"].nil?
#         redirect '/error1_4' # Enter Email
#     end

#     if !User.where("name" => params["name"]).take.nil?
#         redirect '/error1_5' # Nickname is in use. Enter another nickname.
#     end

#     if !User.where("email" => params["email"]).take.nil?
#         redirect '/error1_6' # Email is in use. Enter another Email.
#     end

#     if Company.where("name" => params["company_name"]).take.nil?
#         redirect '/error1_7' # Invalid company name.
#     end

#     if params["name"].length < 2
#         redirect '/error1_8' # Nickname should be longer than 2 syllables
#     end

#     if params["password"].length < 6
#         redirect '/error1_9' # Password should be longer than 6 syllables
#     end

#     if params["password"] != params["password_confirm"]
#         redirect '/error1_10' # Check the Password
#     end

#     if params["phone_number"].length < 10
#         redirect '/error1_11' # Phone number should be longer than 10 numbers
#     end

#     if !params["email"].include? "@" 
#         redirect '/error1_12' # Check Email address
#     elsif !params["email"].include? "."
#         redirect '/error1_13' # Check Email address
#     end

#     user = User.new
#     user.company = Company.find(params["company_name"]) #right?
#     user.nickname = params["nickname"]
#     user.email = params["email"]
#     user.phone_number = params["phone_number"]
#     user.password = BCrypt::Password.create(params["password"])
#     user.current_heart = 0
#     user.location = params["location"]
#     user.team_detail = params["team_datail"]
#     user.profile_img = params["profile_img"]

#     while true
#         user.recommendation_code = SecureRandom.hex(8) # hex(8) -> right????? -> OK
#         break if User.where("recommendation_code" => user.recommendation_code).take.nil?
#     end

#     user.is_male = params["gender"]
#     user.save

#     redirect '/'
# end



# get '/get_matching_result' do
#     check session

# end

# get '/get_my_info' do
#     check session
# end

# post '/edit_my_info_process' do
#     check session

#     if params["password"].nil?
#         redirect '/error1_2' # Enter Password

#     elsif params["password_confirm"].nil?
#         redirect '/error1_3' # Enter Password_confirm

#     if params["password"].length < 6
#         redirect '/error1_9' # Password should be longer than 6 syllables
#     end

#     if params["password"] != params["password_confirm"]
#         redirect '/error1_10' # Check the Password

#     elsif
#         user.company = Company.find(params["company_name"]) #right?
#         user.nickname = params["nickname"]
#         user.email = params["email"]
#         user.phone_number = params["phone_number"]
#         user.password = BCrypt::Password.create(params["password"])
#         user.location = params["location"]
#         user.team_detail = params["team_datail"]
#         user.profile_img = params["profile_img"]
#         user.save

#         redirect '/'
#     end
# end
    
# post '/invite' do
#     check_session

# end