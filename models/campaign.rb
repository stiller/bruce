class Campaign < ActiveRecord::Base
  has_many :selections
  has_many :banners, through: :selections
end
