class Campaign < ActiveRecord::Base
  has_many :selections
  has_many :banners, through: :selections
  accepts_nested_attributes_for :selections, allow_destroy: true

  def self.strategies
    %w(Random Weighted)
  end
end
