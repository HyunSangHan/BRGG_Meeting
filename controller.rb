require 'sinatra'
require './db_class.rb'
require 'bcrypt'


#Sori, Hyunsang
post '/make_ranking' do
    user = Device.find_by_token(params["token"]).user

end

#Sori, Hyunsang
post '/make_matching' do
    user = Device.find_by_token(params["token"]).user

end

# 뽑은순번을 joined에 저장해야겠다..?
#Sori, Hyunsang
post '/cut_off' do
    user = Device.find_by_token(params["token"]).user
    last_male = 
    last_female = 

end

#Sori, Hyunsang
get '/get_my_score' do
    user = Device.find_by_token(params["token"]).user # user_male???
    return Match.all.to_json
end #done

#Sori, Hyunsang
post '/use_heart' do
    user = Device.find_by_token(params["token"]).user

end

#Sori, Hyunsang
get '/get_cash_payment' do
    user = Device.find_by_token(params["token"]).user
    user.cash_payments.to_json
end #done

