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


############## NOT YET!!! ############## 
def join(session)
    if user.nil?
        redirect '/'
    else
        joined_user = JoinedUser.new
        meeting = MeetingDetail.where("meeting_date > ?", Time.now.to_datetime)
                                  .where("starting_date < ?", Time.now.to_datetime).take    
        joined_user.user = user
        joined_user.total_score = 0 # must be added when making cutline
        joined_user.meeting_detail_id = meeting
        joined_user.is_deleted = false

        all_user = meeting.joined_users
        male_count = all_user.where(:is_male => true).count
        female_count = all_user.where(:is_male => false).count

        if user.is_male == true
            joined_user.ranking = male_count
            joined_user.midranking = male_count
        else
            joined_user.ranking = female_count
            joined_user.midranking = female_count
        end

        joined_user.save
    end
end

def assign_first_score(session)
    meeting = MeetingDetail.where("meeting_date > ?", Time.now.to_datetime)
                            .where("starting_date < ?", Time.now.to_datetime).take
    all_user = meeting.joined_users
    cutline = meeting.cutline

    i = cutline
    count = 0
    while 0 < i # for winner
        count = count + 1 
        break if count > 9999
        my = all_user.where("ranking" => i).take
        my.score = DEFAULT_SCORE_RATE + (cutline - my.ranking)*DEFAULT_SCORE_RATE
        my.save
        i -= 1
    end

    i = cutline 
    count = 0
    while i < cutline + DEFAULT_SCORE_RATE # for loser
        count = count + 1 
        break if count > 9999
        i += 1
        my = all_user.where("ranking" => i).take
        my.score = DEFAULT_SCORE_RATE - (my.ranking - cutline) #check if it's int or string
        break if my.score == 0
        my.save
    end
end


def get_ranking_result(session)
    meeting = MeetingDetail.where("meeting_date > ?", Time.now.to_datetime)
                            .where("starting_date < ?", Time.now.to_datetime).take
    all_user = meeting.joined_users
    male_user = all_user.where(:is_male => true)
    female_user = all_user.where(:is_male => false)

    male_user.order("total_score DESC").each_with_index do |xy,i|
        xy.ranking = i + 1
        xy.save
    end

    female_user.order("total_score DESC").each_with_index do |xx,j|
        xx.ranking = j + 1
        xx.save
    end
    
    return meeting.joined_user.ranking #need check. need return?
end

def get_cutline    
    meeting = MeetingDetail.where("meeting_date > ?", Time.now.to_datetime)
                            .where("starting_date < ?", Time.now.to_datetime).take
    all_user = meeting.joined_users
    
    #doo2's comment ----> all_user = JoinedUser.where(:meeting_detail_id = meeting.id)
                          
    female_count = all_user.where(:is_male => false).count
    male_count = all_user.where(:is_male => true).count

    return cutline = [female_count, male_count].min
end

def use_heart(session)
    meeting = MeetingDetail.where("meeting_date > ?", Time.now.to_datetime)
                            .where("starting_date < ?", Time.now.to_datetime).take
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

post '/use_cash' do #done
    user = Device.find_by_token(params["token"]).user
    
    
    cash_payment = CashPayment.new
    cash_payment.user = user
    cash_payment.cash = params["cash_payment"]
    cash_payment.heart = cash_payment.cash * CASH_TO_HEART 
    cash_payment.save

    user.current_heart = user.current_heart + cash_payment.heart
    user.save

    return cash_payment.to_json
end

