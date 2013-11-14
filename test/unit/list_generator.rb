require File.expand_path(File.dirname(__FILE__) + '/../../lib/list_generator.rb')
require 'minitest/autorun'
require 'ostruct'

describe ListGenerator do
  it 'combines the results of two random generators' do
    random_banners   = [OpenStruct.new(url: 'random', weight: 1)]
    weighted_banners = [OpenStruct.new(url: 'weighted', weight: 1)]
    list = ListGenerator.new(Random.new(random_banners),
                             Weighted.new(weighted_banners),30,70)
    list.pick(15).find_all{ |banner| banner.url == 'random' }.count.must_equal 5
    list.pick(15).find_all{ |banner| banner.url == 'weighted' }.count.must_equal 10
  end
end
