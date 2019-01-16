require 'sinatra'
require './db_class.rb'
require 'bcrypt'


####################
# making (change to function)
###################






# <get>
# get_ranking_result - HS (Y)
# get_cash_payment - WJ (Y)
# get_heart_payment - WJ (Y)
# get_cutline - SR

# join
# certify_company - ...

# use_cash - WJ
# use_heart - WJ (WIP)

# make_ranking + assign_first_score

############## HS ############## 

#####WJ########
get '/get_cash_payment' do 
    user = Device.find_by_token(params["token"]).user

    return user.cash_payments.to_json 
end


get '/get_heart_payment' do 
    user = Device.find_by_token(params["token"]).user

    return user.heart_payments.to_json
end


post '/join' do
    user = Device.find_by_token(params["token"]).user #in case of web change to session
    joined_user = JoinedUser.new

    if user.nil?
        return "error_1".to_json
    else
        joined_user.user = user
        joined_user.total_score = 0 # must be added when making cutline
        joined_user.ranking = joined_user_id + 1 # Is it right?? separate male/female 
        #add logic for when two users are exactly the same, infinite loop
        joined.matching = false
        joined.meeting_date = params["meeting_date"] # Actually...I don't know how to take meeting_date! -> fetch from meeting detail 
        joined_user.save

        return joined_user.ranking.to_json
    end
end

post '/assign_first_score' do
    joined_user = joined_user.where("meeting_date" => params["meeting_date"]).take # params meeting_date... Is it right?
    i = cutline # but....how to get cutline...?

    while 0 < i # for winner
        #count = count + 1 
        #break if count > 9999 
        joined_user = joined_user.where("ranking" => i).take
        joined_user.score = DEFAULT_SCORE_RATE + (cutline - joined_user.ranking)*DEFAULT_SCORE_RATE
        joined_user.save
        i -= 1
    end

    while i < cutline + DEFAULT_SCORE_RATE # for loser
        i += 1
        joined_user = joined_user.where("ranking" => i).take
        joined_user.score = DEFAULT_SCORE_RATE - (joined_user.ranking - cutline) #check if it's int or string
        if joined_user.score == 0
            return false
        end
        joined_user.save
    end
end


def get_ranking_result
    meeting = MeetingDetail.where("meeting_date > ?", Time.now)
                            .where("starting_date < ?", Time.now).take
    all_user = meeting.joined_users
    ############################################
    # have to add a logic for calculating raking

    # JoinedUser.includes( :ranking ).order( 'joined_user.scores DESC' )
end

def get_cutline    
    meeting = MeetingDetail.where("meeting_date > ?", Time.now)
                            .where("starting_date < ?", Time.now).take
    

    all_user = meeting.joined_users
    
    #doo2's comment ----> all_user = JoinedUser.where(:meeting_detail_id = meeting.id)
                          
    female_count = all_user.where(:is_male => false).count
    male_count = all_user.where(:is_male => true).count

    return cutline = [female_count, male_count].min
end

    
post '/make_ranking' do
    user = Device.find_by_token(params["token"]).user

    # <get user lists>
    sametime_users = joined_users.where("meeting date" => params["meeting date"])
    male_users = sametime_users.where("gender" => "male")
    female_users = sametime_users.where("gender" => "female") # right syntax?

    # <fix ranking by total_score>

    # tmp = male_users.sort_by{|user_id, total_score, ranking, matching, timestamp, meeting_date|total_score}
    # for i in tmp
    #     tmp.ranking = i
    # end

    # # user_id
    # # total_score
    # # ranking
    # # matching (boolean)
    # # meeting_date
    

    # <have to fix matching>
    
    # <make matched history(Class)>

end

post '/use_heart' do #error??
    user = Device.find_by_token(params["token"]).user
    joined_user = JoinedUser.New
    joined_user.user_id = user_id
    joined_user.total_score = total_score
    joined_user.ranking =ranking

    if joined_user.ranking == 1 #or is it '0'?
        return "error".to_json #already first ranking and cannot upgrade
    end

    #check whether user used heart in time

    #if heart is used, add points accordingly
    joined_user.total_score = joined_user.total_score + (heart_paid * HEART_TO_SCORE) #how much points is a heart worth??????

    #deduct heart from original heart amount
    user.current_heart = user.current_heart - heart_paid
    #add heart useage for heartpayment
    
   
    joined_user.save
    heart_payment.save
    user.save
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

post '/use_cash' do #error??
    user = Device.find_by_token(params["token"]).user
    
        cash_payment = CashPayment.new
        cash_payment.user = user
        cash_payment.cash = params["cash_payment"]
        cash_payment.heart = cash_payment.cash * CONST
        cash_payment.save

        user.save
        cash_payment.save
end

###########################  HS's version about WJ's part(/use_cash)
# post '/use_cash' do #done
#     user = Device.find_by_token(params["token"]).user
    
#     
#     cash_payment = CashPayment.new
#     cash_payment.user = user
#     cash_payment.cash = params["cash_payment"]
#     cash_payment.heart = cash_payment.cash * CASH_TO_HEART 
#     cash_payment.save

#     user.current_heart = user.current_heart + cash_payment.heart
#     user.save

#     return cash_payment.to_json
# end

