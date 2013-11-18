require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe 'The Bruce App' do
  before do
    $redis.flushdb
    campaign = Campaign.create(strategy1: 'random', strategy2: 'weighted', ratio1: 1, ratio2: 2)
    campaign.banners << Banner.create(url: 'foo')
    campaign.selections.first.update_attributes(enabled: true, weight: 1)
  end

  after do
    Campaign.delete_all
    Banner.delete_all
  end

  it 'returns an image tag' do
    get '/'
    assert last_response.ok?
    assert last_response.body.include?('img')
    url = last_response.body.match(/src='(.*)'/)[1]
    url.must_equal 'foo'
  end
end
