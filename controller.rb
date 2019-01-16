require 'sinatra'
require './db_class.rb'
require './function.rb'
require 'bcrypt'

enable :sessions


# (Done: Y / Not yet: N / I don't know how to do: ...)
# <get>
# get_ranking_result - HS (Y)
# get_cash_payment - WJ (Y)
# get_heart_payment - WJ (Y)
# get_matching_result - SJ
# get_my_info - SJ
# get_cutline - SR

# <post>
# join - HS (Y)
# assign_first_score - HS (Y)
# sign_up - HS (Y)
# secession - HS (Y)
# sign_in - HS (Y)
# logout - HS (Y)
# certify_company - ...
# use_cash - WJ
# use_heart - WJ (WIP)
# edit_my_info - SJ
# make_ranking - SR
# invite - SR
# make_chatingroom - ...
# find_lost_password - ...

DEFAULT_SCORE_RATE = 100
CASH_TO_HEART = 1
HEART_TO_SCORE = 1000


get '/get_cash_payment' do 
    user = User.find(session["user_id"]
#    return user.cash_payments.to_json 
    redirect '/'
end


get '/get_heart_payment' do 
    user = User.find(session["user_id"])
 #   return user.heart_payments.to_json
    redirect '/'
end

post '/sign_up' do
    if params["nickname"].nil?
        return "error_1_1".to_json # Enter Nickname  to_json -> redirect

    elsif params["password"].nil?
        return "error_1_2".to_json # Enter Password

    elsif params["password_confirm"].nil?
        return "error_1_3".to_json # Enter Password_confirm

    elsif params["email"].nil?
        return "error_1_4".to_json # Enter Email
    end

    if !User.where("name" => params["name"]).take.nil?
        return "error_1_6".to_json # Nickname is in use. Enter another nickname.
    end

    if !User.where("email" => params["email"]).take.nil?
        return "error_1_7".to_json # Email is in use. Enter another Email.
    end

    if Company.where("name" => params["company_name"]).take.nil?
        return "error_1_8".to_json # Invalid company name.
    end

    if params["name"].length < 2
        return "error_1_9".to_json # Nickname should be longer than 2 syllables
    end

    if params["password"].length < 6
        return "error_1_10".to_json # Password should be longer than 6 syllables
    end

    if params["password"] != params["password_confirm"]
        return "error_1_11".to_json # Check the Password
    end

    if params["phone_number"].length < 10
        return "error_1_12".to_json # Phone number should be longer than 10 numbers
    end

    if !params["email"].include? "@" 
        return "error_1_13" # Check Email address
    elsif !params["email"].include? "."
        return "error_1_14" # Check Email address
    end

    if !params["gender"] != "male" && !params["gender"] != "female" 
        return "error_1_15" # Invalid gender
    end

    user = User.new
    user.company = Company.find(params["company_name"]) #right?
    user.nickname = params["nickname"]
    user.email = params["email"]
    user.phone_number = params["phone_number"]
    user.password = BCrypt::Password.create(params["password"])
    user.current_heart = 0
    user.location = params["location"]
    user.team_detail = params["team_datail"]
    user.profile_img = params["profile_img"]

    while true
        user.recommendation_code = SecureRandom.hex(8) # hex(8) -> right????? -> OK
        return User.where("recommendation_code" => user.recommendation_code).take.nil? 
    end

    user.gender = params["gender"]
    user.created_at = Time.now
    user.save

    device = Device.new
    device.user = user 
    device.token = SecureRandom.uuid 
    device.save

    return device.to_json
end

post '/sign_in' do
    user = User.find_by_email(params["email"])

    if user.nil?
        return "error_2_1".to_json #to_json -> redirect
    end
    
    if BCrypt::Password.new(user.password) != params["password"] # I don't know it exactly..
        return "error_2_2".to_json #to_json -> redirect
    end

    device = Device.new
    device.user = user
    device.token = SecureRandom.uuid
    device.save
    return device.to_json
end

post '/logout' do #reset session
    session.clear
    redirect '/'
end

post '/secession' do
    user = User.find(session["user_id"])
    if user.password != params["password"] # No BCyrpt???
        redirect '/error_3'
    else
        user.delete
        redirect '/'
    end
end

# post '/make_new_meeting' do
#     matching = Matching.new # matching db in server??
#     joined_male = JoinedMaleUser.new
#     joined_female = JoinedFemaleUser.new

#     matching.meeting_date = getMeetingDate # It needs new function
#     matching.joined_male = joined_male
#     matching.joined_female = joined_female
#     matching.save

#     return matching.to_json
# end

# # it called when user clicked the meeting participating button
# post '/add_user_to_meeting' do
#     user = Device.find_by_token(params["token"]).user
#     meeting = getCurrentMeeing # matching db in server?? find_by

#     if inTime # It need to compare matching.meeting_date, getCurrentTime
#         if user.gender == 'male'
#             if matching.joined_male.nil?
#                 return "error".to_json # It means meeting
#             else
#                 joined_male.user_id = user.user_id
#                 joined_male.current_raking = joined_male.id
#                 joined_male.save
#                 return joined_male.to_json
#         else # female user same with male




#     else
#         return "error" # It means user can't join the meeting
# end

# # it called when the first meeting set.
# post '/make_joined_user_first_list' do
#     joined_male = getJoinedMale # It needs new function
#     joined_female = getJoinedFemale

#     setCutline = min(joined_male.last.current_raking, joined_female.last.current_raking) # I think meeting db needs cutline for fast calc
#     setjoinedUserDB # calc total score with cutline
# end

# # it called when each time to sorting user list
# post '/sorting_joined_user_list' do
#     # quick sort joined user by total_score
#     # googling
# end


get '/get_matching_result' do
    user = User.find(session["user_id"])

end

get '/get_my_info' do
    @user = User.find(session["user_id"])
end

post '/edit_my_info' do
    user = User.find(session["user_id"])

    if params["password"].nil?
        return "error_1_2".to_json # Enter Password

    elsif params["password_confirm"].nil?
        return "error_1_3".to_json # Enter Password_confirm

    if params["password"].length < 6
        return "error_1_10".to_json # Password should be longer than 6 syllables
    end

    if params["password"] != params["password_confirm"]
        return "error_1_11".to_json # Check the Password

    elsif
        user.company = Company.find(params["company_name"]) #right?
        user.nickname = params["nickname"]
        user.email = params["email"]
        user.phone_number = params["phone_number"]
        user.password = BCrypt::Password.create(params["password"])
        user.location = params["location"]
        user.team_detail = params["team_datail"]
        user.profile_img = params["profile_img"]
        return user.to_json
    end
end

    
post '/invite' do
    user = User.find(session["user_id"])

end