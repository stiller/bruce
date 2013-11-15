class Banner < ActiveRecord::Base
  has_many :selections
  has_many :campaigns, through: :selections

  def ==(another_banner)
    self.url == another_banner.url
  end
end
