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

  it 'picks the right amount of banners' do
    RandomBanner.new(@banners).pick(3).size.must_equal 3
    RandomBanner.new(@banners).pick(10).size.must_equal 10
  end

  it 'picks 11 different banners' do
    random_banners = RandomBanner.new(@banners).pick(11)
    random_banners.map(&:name).uniq.size.must_equal 11
  end
end
