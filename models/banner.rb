class Banner < ActiveRecord::Base
  def ==(another_banner)
    self.url == another_banner.url
  end
end
