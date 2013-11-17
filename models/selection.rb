class Selection < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :banner
  accepts_nested_attributes_for :banner
end
