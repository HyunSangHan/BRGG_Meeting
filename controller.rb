require 'sinatra'
require './db_class.rb'
require 'bcrypt'


# <get>
# 첫번호
# 충전한내역
# 하트쓴내역
# 결과번호
# 매칭상대
# 내정보보기
# 커트라인확정

# <post>
# 회원가입
# 회원탈퇴
# 로그인
# 로그아웃
# 하트충천
# 하트사용
# 랭킹만들기(나래비세우기)
# 초대하기(공유하기)
# 내정보수정
# 대화방열어주기(get인가?)

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

