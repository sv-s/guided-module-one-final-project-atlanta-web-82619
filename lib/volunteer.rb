class Volunteer < ActiveRecord::Base
    has_many :logs
    has_many :organizations, through: :logs
    has_many :reviews
end 