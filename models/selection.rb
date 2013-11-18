class Selection < ActiveRecord::Base
  belongs_to :campaign
  belongs_to :banner
  accepts_nested_attributes_for :banner
  scope :enabled, -> { where(enabled: true) }
  delegate :url, to: :banner

  def ==(another_banner)
    self.url == another_banner.url
  end
end
