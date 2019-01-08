require 'sinatra'
require './db_class.rb'
require 'bcrypt'

# (Done: Y / Not yet: N / I don't know how to do: ...)
# <get>
# get_first_score - HS (Y)
# get_ranking_result - HS (Y)
# get_cash_payment - WJ (Y)
# get_heart_payment - WJ (Y)
# get_matching_result - SJ
# get_my_info - SJ
# get_cutline - SR

# <post>
# join - HS (Y)
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


############## HS ############## 
post '/join' do
    user = Device.find_by_token(params["token"]).user
    joined_user = JoinedUser.new

    if user.nil?
        return "error_1".to_json
    else
        joined_user.user = user
        joined_user.total_score = 0 # must be added when making cutline
        joined_user.ranking = joined_user_id + 1 # Is it right??
        joined.matching = false
        joined.meeting_date = params["meeting_date"] # Actually...I don't know how to take meeting_date!
        joined_user.save

        return joined_user.ranking.to_json
    end
end

post '/give_first_score' do
    joined_user = joined_user.where("meeting_date" => params["meeting_date"]).take # params meeting_date... Is it right?
    i = cutline # but....how to get cutline...?
    STANDARD_SCORE = 100

    while 0 < i # for winner
        joined_user = joined_user.where("ranking" => i).take
        joined_user.score = STANDARD_SCORE + (cutline - joined_user.ranking)*STANDARD_SCORE
        joined_user.save
        i -= 1
    end

    while i < cutline + STANDARD_SCORE # for loser
        i += 1
        joined_user = joined_user.where("ranking" => i).take
        joined_user.score = STANDARD_SCORE - (joined_user.ranking - cutline)
        if joined_user.score == 0
            return false
        end
        joined_user.save
    end
end

get '/get_ranking_result' do
    user = Device.find_by_token(params["token"]).user
    joined_user = user.joined_user.where("meeting_date" => params["meeting_date"]).take # params meeting_date... Is it right?

    if joined_user.nil?
        return "error_2".to_json
    else
        return joined_user.ranking.to_json
    end
end

post '/sign_up' do
    if params["nickname"].nil?
        return "error_1_1".to_json # Enter Nickname

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
        user.recommendation_code = SecureRandom.hex(8) # hex(8) -> right?????
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
        return "error_2_1".to_json
    end
    
    if BCrypt::Password.new(user.password) != params["password"] # I don't know it exactly..
        return "error_2_2".to_json
    end

    device = Device.new
    device.user = user
    device.token = SecureRandom.uuid
    device.save
    return device.to_json
end

post '/logout' do
    Device.find_by_token(params["token"]).delete
    return true.to_json
end

post '/secession' do
    user = Device.find_by_token(params["token"]).user
    if user.password != params["password"] # No BCyrpt???
        return "error_3".to_json
    else
        user.delete
        return true.to_json 
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

#####WJ########
get '/get_cash_payment' do 
    user = Device.find_by_token(params["token"]).user

    return user.cash_payments.to_json
end


get '/get_heart_payment' do 
    user = Device.find_by_token(params["token"]).user

    return user.heart_payments.to_json
end


###########################  HS's version about WJ's part(/use_cash)
# post '/use_cash' do #done
#     user = Device.find_by_token(params["token"]).user
    
#     CONST = 1

#     cash_payment = CashPayment.new
#     cash_payment.user = user
#     cash_payment.cash = params["cash_payment"]
#     cash_payment.heart = cash_payment.cash * CONST
#     cash_payment.save

#     user.current_heart = user.current_heart + cash_payment.heart
#     user.save

#     return cash_payment.to_json
# end


# WJchung
post '/use_heart' do #error??
    user = Device.find_by_token(params["token"]).user
    joined_user = user.joined_user.find(params["user_id"])
    joined_user = Joined_user.new

    if joined_user.ranking == 1 #or is it '0'?
        return "error".to_json #already first ranking and cannot upgrade
    end

    #check whether user used heart in time

    #if heart is used add points accordingly
    joined_user.total_score = joined_user.total_score + (heart_paid * 1000) #how much points is a heart worth??????
    #new ranking??????
    #deduct heart from original heart amount
    user.current_heart = user.current_heart - heart_paid
    #add heart useage for heartpayment
    

    upgrade.myanimal = myanimal
    upgrade.growth_step = myanimal.growth_step
   
    joined_user.save
    heart_payment.save
    cash_payment.save
    joined_user.to_json

end


###########################  HS's version about WJ's part(/use_heart)
# post '/use_heart' do #done
#     user = Device.find_by_token(params["token"]).user
#     joined_user = user.joined_user.where("meeting_date" => params["meeting_date"]).take # params meeting_date... Is it right?
#     total_score = joined_user.total_score

#     heart_payment = HeartPayment.new
#     heart_payment.user = user
#     heart_payment.heart_paid = params["heart_payment"]

#     total_score = total_score + heart_payment.heart_paid    

#     user.current_heart = user.current_heart - heart_payment.heart_paid

#     heart_payment.save
#     user.save

#     return heart_payment.to_json
# end

