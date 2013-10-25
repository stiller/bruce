require 'minitest/autorun'

class RandomBanner
  def initialize banners
    @banners = banners
  end

  def pick number
    @banners.sample(number)
  end
end

describe RandomBanner do
  before do
    @banners = %w(red green blue black purple yellow violet grey orange pink brown)
  end

  it 'picks a number of banners randomly, given a set of banners' do
    random_banners = RandomBanner.new(@banners).pick(5)
    random_banners.size.must_equal 5
  end
end
