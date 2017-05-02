class User < ApplicationRecord
  has_and_belongs_to_many :facilities
  has_many :use_times
end
