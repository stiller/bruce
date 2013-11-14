require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe 'The Bruce App' do
  before do
    Banner.create(url: 'foo', weight: 1)
  end

  after do
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
