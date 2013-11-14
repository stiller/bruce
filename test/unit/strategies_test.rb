require File.expand_path(File.dirname(__FILE__) + '/../../lib/strategies.rb')
require 'minitest/autorun'
require 'ostruct'

module Strategies
  describe Random do
    before do
      banner_urls = %w(red green blue black purple yellow violet grey orange pink brown)
      @banners = banner_urls.each_with_index.map{ |u,i| OpenStruct.new(url: u, weight: i) }
    end

    it 'picks the right amount of banners' do
      Random.new(@banners).pick(3).size.must_equal 3
      Random.new(@banners).pick(10).size.must_equal 10
    end

    it 'picks 11 different banners' do
      random_banners = Random.new(@banners).pick(11)
      random_banners.map(&:url).uniq.size.must_equal 11
    end

    describe Weighted do
      it 'will probably - but not always - pick a banner with a very high weight' do
        @banners.find{ |b| b.url == 'red' }.weight = 999
        random_banners = Weighted.new(@banners).pick(2)
        assert random_banners.find{|rb| rb.url == 'red'}
      end

      it 'probably will not - but might - pick a banner with a very low weight' do
        @banners.each { |b| b.weight = 999 }
        @banners.find{ |b| b.url == 'red' }.weight = 1
        random_banners = Weighted.new(@banners).pick(2)
        refute random_banners.find{ |rb| rb.url == 'red' }
      end
    end
  end

end
