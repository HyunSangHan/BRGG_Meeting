require 'sinatra'
require './db_class.rb'
require 'bcrypt'


####################
# I am still making code~~~~~~ (for changing get/post to function)
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




############## NOT YET ############## 
def join(session)
    if user.nil?
        redirect '/'
    else
        joined_user = JoinedUser.new
        meeting = MeetingDetail.where("meeting_date > ?", Time.now)
                                  .where("starting_date < ?", Time.now).take    
        joined_user.user = user
        joined_user.total_score = 0 # must be added when making cutline

        all_user = meeting.joined_users
 
        female_count = all_user.where(:is_male => false).count
        male_count = all_user.where(:is_male => true).count

        joined_user.ranking = joined_user_id + 1 # Is it right?? separate male/female 
        joined_user.midranking = joined_user_id + 1
        #add logic for when two users are exactly the same, infinite loop
        joined_user.meeting_detail_id = meeting
        joined_user.is_deleted = false
        joined_user.save
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


def get_ranking_result(session)
    meeting = MeetingDetail.where("meeting_date > ?", Time.now)
                            .where("starting_date < ?", Time.now).take
    # meeting = MeetingDetail.first
    meeting.joined_users.order("total_score DESC").each_with_index do |x,i|
    x.ranking = i + 1
    x.save
    return meeting.joined_user.ranking #need check
    #how about gender??????????????????????
end

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

def use_heart(session)
    meeting = MeetingDetail.where("meeting_date > ?", Time.now)
                            .where("starting_date < ?", Time.now).take
    all_user = meeting.joined_users


    total_score = all_user.total_score

    heart_payment = HeartPayment.new
    heart_payment.user = user
    heart_payment.heart_paid = params["heart_payment"]

    joined_user.total_score = joined_user.total_score + (heart_payment.heart_paid * HEART_TO_SCORE)

    user.current_heart = user.current_heart - heart_payment.heart_paid

    heart_payment.save
    user.save
#     return heart_payment.to_json
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

