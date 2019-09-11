class Organization < ActiveRecord::Base
    has_many :logs
    has_many :volunteers, through: :logs
    # has_many :reviews,through: :logs
end 