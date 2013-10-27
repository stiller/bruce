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
    banners(number).sample(number)
  end

  def banners number
    more_banners = @banners
    while more_banners.count < number do
      more_banners += @banners
    end
    more_banners
  end
end

class WeightedBanner < RandomBanner
  def pick number
    pick_list = []
    banners(number).each { |banner| banner.weight.times { pick_list << banner } }
    pick_list.sample(number)
  end
end

class ListGenerator
  def initialize gen_a, gen_b, ratio_a, ratio_b
    gcd = ratio_a.gcd(ratio_b)
    @ratio_a = ratio_a / gcd
    @ratio_b = ratio_b / gcd
    @gen_a = gen_a
    @gen_b = gen_b
  end

  def pick number
    mult = number / (@ratio_a + @ratio_b)
    @gen_a.pick(mult * @ratio_a) + @gen_b.pick(mult * @ratio_b)
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

describe ListGenerator do
  it 'combines the results of two random generators' do
    random_banners = {'random'=> 1}
    weighted_banners = {'weighted' => 1}
    list = ListGenerator.new(RandomBanner.new(random_banners),
                             WeightedBanner.new(weighted_banners),3,7)
    list.pick(10).find_all{ |banner| banner.name == 'weighted' }.count.must_equal 7
    list.pick(10).find_all{ |banner| banner.name == 'random' }.count.must_equal 3
  end
end
