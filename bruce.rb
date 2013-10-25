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
  attr_reader :banners

  def initialize banner_hash
    @banners = banner_hash.map { |k,v| Banner.new(k,v) }
  end

  def pick number
    @banners.sample(number)
  end
end

class WeightedBanner < RandomBanner
  def pick number
    pick_list = []
    @banners.each { |banner| banner.weight.times { pick_list << banner } }
    pick_list.sample(number)
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

  describe WeightedBanner do
    it 'will probably - but not always - pick a banner with a very high weight' do
      @banners['red'] = 999
      random_banners = WeightedBanner.new(@banners).pick(2)
      assert random_banners.find{|rb| rb.name == 'red'}
    end

    it 'probably will not - but might - pick a banner with a very low weight' do
      @banners.each { |k,v| v = 99 }
      @banners['red'] = 1
      random_banners = WeightedBanner.new(@banners).pick(2)
      refute random_banners.find{ |rb| rb.name == 'red' }
    end
  end
end
