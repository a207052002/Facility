class Facility < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :rents
  has_many :allow_users
end
