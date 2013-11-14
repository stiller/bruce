require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

module Strategies
  describe RandomBanner do
    before do
      banner_urls = %w(red green blue black purple yellow violet grey orange pink brown)
      banner_weights = (1..11).to_a
      @banners = Hash[banner_urls.zip(banner_weights)]
    end

    it 'picks the right amount of banners' do
      RandomBanner.new(@banners).pick(3).size.must_equal 3
      RandomBanner.new(@banners).pick(10).size.must_equal 10
    end

    it 'picks 11 different banners' do
      random_banners = RandomBanner.new(@banners).pick(11)
      random_banners.map(&:url).uniq.size.must_equal 11
    end

    describe WeightedBanner do
      it 'will probably - but not always - pick a banner with a very high weight' do
        @banners['red'] = 999
        random_banners = WeightedBanner.new(@banners).pick(2)
        assert random_banners.find{|rb| rb.url == 'red'}
      end

      it 'probably will not - but might - pick a banner with a very low weight' do
        @banners.each { |k,v| v = 99 }
        @banners['red'] = 1
        random_banners = WeightedBanner.new(@banners).pick(2)
        refute random_banners.find{ |rb| rb.url == 'red' }
      end
    end
  end

  describe ListGenerator do
    it 'combines the results of two random generators' do
      random_banners = {'random'=> 1}
      weighted_banners = {'weighted' => 1}
      list = ListGenerator.new(RandomBanner.new(random_banners),
                               WeightedBanner.new(weighted_banners),30,70)
      list.pick(15).find_all{ |banner| banner.url == 'random' }.count.must_equal 5
      list.pick(15).find_all{ |banner| banner.url == 'weighted' }.count.must_equal 10
    end
  end
end
