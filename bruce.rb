require 'minitest/autorun'
require 'pry'

class Banner
  attr_reader :name, :weight

  def initialize(name, weight=1)
    @name = name
    @weight = weight
  end
end

class RandomBanner
  def initialize banner_hash
    @banners = banner_hash.map { |k,v| Banner.new(k,v) }
  end

  def pick number
    @banners.sample(number)
  end
end

describe RandomBanner do
  before do
    banner_names = %w(red green blue black purple yellow violet grey orange pink brown)
    banner_weights = (1..11).to_a
    @banners = Hash[banner_names.zip(banner_weights)]
  end

  it 'picks a number of banners randomly, given a set of banners' do
    random_banners = RandomBanner.new(@banners).pick(5)
    random_banners.size.must_equal 5
    random_banners.combination(2).each do |first, second|
      first.name.wont_equal second.name # we are not expecting repetition
    end
  end
end
