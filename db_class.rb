require 'sinatra/activerecord'
#require 'bcrypt'

############# DB definition
# company, cash_payment, heart_payment, user_male, user_female, joined_male, joined_female, match

class Company < ActiveRecord::Base
	has_many :user_males
    has_many :user_females
end

class CashPayment < ActiveRecord::Base
	belongs_to :user_male #Is it right...?? (has one??)
    belongs_to :user_female
end

class UsedHeart < ActiveRecord::Base
	belongs_to :user_male
    belongs_to :user_female
end

class UserMale < ActiveRecord::Base
    has_many :devices
    has_many :cash_payments
    has_many :used_hearts
    has_many :joined_males #Is it right...?? (has one??)
    has_many :matches, through :joined_male
end

class UserFemale < ActiveRecord::Base
	has_many :devices
    has_many :cash_payments
    has_many :used_hearts
    has_many :joined_females
    has_many :matches, through :joined_female
end

class JoinedMale < ActiveRecord::Base
	belongs_to :user_male
    has_one :match
    has_one :joined_male, through :match
end

class JoinedFemale < ActiveRecord::Base
	belongs_to :user_female
    has_one :match
    has_one :joined_female, through :match
end

class Match < ActiveRecord::Base
	has_many :joined_males
    has_many :joined_females
    has_many :user_males, through :joined_male
    has_many :user_females, through :joined_female
end

class Device < ActiveRecord::Base
	belongs_to :user_male
    belongs_to :user_female
end