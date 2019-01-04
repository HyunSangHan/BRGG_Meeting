require 'sinatra'
require './db_class.rb'
require 'bcrypt'

# (Done: Y / Not yet: N / I don't know how to do: ...)
# <get>
# get_first_result - HS (Y)
# get_final_result - HS (Y)
# get_cash_payment - WJ
# get_heart_payment - WJ
# get_matching_result - SJ
# get_my_info - SJ
# get_cutline - SR

# <post>
# sign_up - HS (Y)
# secession - HS (Y)
# sign_in - HS (Y)
# logout - HS (Y)
# certify_company - ...
# use_cash - WJ
# use_heart - WJ
# edit_my_info - SJ
# make_ranking - SR
# invite - SR
# make_chatingroom - ...
# find_lost_password - ...


############## HS ############## 
get '/get_first_result' do
    user = Device.find_by_token(params["token"]).user
    joined_user = JoinedUser.new

    if user.nil?
        return "error_1".to_json
    else
        joined_user.user = user
        joined_user.total_score = 0 # must be added when making cutline
        joined_user.ranking = joined_user_id # Is it right??
        joined.matching = false
        joined.meeting_date = params["meeting_date"] # Actually...I don't know how to take meeting_date!
        joined_user.save

        return joined_user.ranking.to_json
    end
end

get '/get_final_result' do
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



############## WJ ############## 
get '/get_cash_payment' do #done
    user = Device.find_by_token(params["token"]).user
    return user.cash_payment.to_json
end

get '/get_heart_payment' do #done
    user = Device.find_by_token(params["token"]).user
    return user.heart_payment.to_json
end

post '/use_cash' do #done
    user = Device.find_by_token(params["token"]).user
    
    CONST = 1

    cash_payment = CashPayment.new
    cash_payment.user = user
    cash_payment.cash = params["cash_payment"]
    cash_payment.heart = cash_payment.cash * CONST
    cash_payment.save

    user.current_heart = user.current_heart + cash_payment.heart
    user.save

    return cash_payment.to_json
end

post '/use_heart' do #done
    user = Device.find_by_token(params["token"]).user
    joined_user = user.joined_user.where("meeting_date" => params["meeting_date"]).take # params meeting_date... Is it right?
    total_score = joined_user.total_score

    heart_payment = HeartPayment.new
    heart_payment.user = user
    heart_payment.heart_paid = params["heart_payment"]

    total_score = total_score + heart_payment.heart_paid    

    user.current_heart = user.current_heart - heart_payment.heart_paid

    heart_payment.save
    user.save

    return heart_payment.to_json
end


############## SJ ############## 
get '/get_matching_result' do
    user = Device.find_by_token(params["token"]).user

end

get '/get_my_info' do
    user = Device.find_by_token(params["token"]).user
    return user.to_json
end

post '/edit_my_info' do
    user = Device.find_by_token(params["token"]).user

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


############## SR ############## 
get '/get_cutline' do
    user = Device.find_by_token(params["token"]).user

end

post '/make_ranking' do

end

post '/invite' do
    user = Device.find_by_token(params["token"]).user

end
