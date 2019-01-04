require 'sinatra/activerecord'
#require 'bcrypt'

############# DB definition

class Company < ActiveRecord::Base
	has_many :users
end

class CashPayment < ActiveRecord::Base
	belongs_to :user
end

class HeartPayment < ActiveRecord::Base
	belongs_to :user
end

class User < ActiveRecord::Base
    belongs_to :company
    has_many :devices
    has_one :cash_payment
    has_one :heart_payment
    has_many :joined_users
end

class JoinedUser < ActiveRecord::Base
	belongs_to :user

class MatchedHistory < ActiveRecord::Base
	belongs_to :user
end

class Device < ActiveRecord::Base
	belongs_to :user
end