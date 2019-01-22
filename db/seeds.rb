require 'securerandom'
require 'bcrypt'
require './db_class.rb'

meeting_detail = Meeting_detail.create("starting_date"=>Time.now(), "mid_date"=>Time.now(), "meeting_date"=>Time.now(), \
"location"=>"Gangnam", "cutline"=>"0")
# I don't know exactly.... about datetime....

for i in 1..20 #for men
    j = i % 4 + 1

    company = Company.create("name"=>"BRGG#{j}", "domain"=>"@#{j}mail.com")
    company.save

    a=Company.find_by_id(i)

    user = User.create("company_id" => a.id, "current_heart" => i, "nickname"=>"user#{i}", "email"=>"#{i}@#{i}mail.com", \
    "password"=>"abc#{i}#{i}#{i}#{i}", "phone_number"=>"#{i}#{i}#{i}-#{i}#{i}#{i}#{i}-#{i}#{i}#{i}#{i}", \
    "location"=>"Gangnam", "profile_img"=>"/public/images/guest#{j}", "recommendation_code"=>"abcd#{i}#{i}",\
    "team_detail"=>"Hi Nice to meet you", "is_male"=>true, "created_at"=>Time.now())
    user.password = BCrypt::Password.create(user.password)
    user.save

    b=User.find_by_id(i)

    joined_user = JoinedUser.create("user_id"=>b.id, "meeting_detail_id"=>1, "total_score"=>0,\
    "ranking"=>i,"midranking"=>i, "is_deleted"=>false, "created_at"=>Time.now())
end

for i in 21..30 #for women
    j = i % 4 + 1

    company = Company.create("name"=>"BRGG#{j}", "domain"=>"@#{j}mail.com")
    company.save

    a=Company.find_by_id(i)

    user = User.create("company_id" => a.id, "current_heart" => i, "nickname"=>"user#{i}", "email"=>"#{i}@#{i}mail.com", \
    "password"=>"abc#{i}#{i}#{i}#{i}", "phone_number"=>"#{i}#{i}#{i}-#{i}#{i}#{i}#{i}-#{i}#{i}#{i}#{i}", \
    "location"=>"Gangnam", "profile_img"=>"/public/images/guest#{j}", "recommendation_code"=>"abcd#{i}#{i}",\
    "team_detail"=>"Hi Nice to meet you", "is_male"=>false, "created_at"=>Time.now())
    user.password = BCrypt::Password.create(user.password)
    user.save

    b=User.find_by_id(i)

    joined_user = JoinedUser.create("user_id"=>b.id, "meeting_detail_id"=>1, "total_score"=>0,\
    "ranking"=>i,"midranking"=>i, "is_deleted"=>false, "created_at"=>Time.now())
end
