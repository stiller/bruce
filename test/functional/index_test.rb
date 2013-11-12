require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe 'The Bruce App' do
  before do
    Banner.create(url: 'foo', weight: low_weight)
  end

  after do
    Banner.delete_all
  end

  it 'returns an image tag' do
    get '/'
    assert last_response.ok?
    assert last_response.body.include?('img')
  end

  it 'never returns the same banner twice for at least two banners' do
    Banner.create(url: 'bar', weight: low_weight)
    previous = ''
    4.times do
      get '/'
      url = last_response.body.match(/src='(.*)'/)[1]
      assert url != previous
      previous = url
    end
  end
end

def high_weight
  100
end

def low_weight
  1
end
