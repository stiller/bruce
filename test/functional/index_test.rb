require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe 'The Bruce App' do
  before do
    Banner.create(url: 'foo', weight: 42)
  end

  after do
    Banner.delete_all
  end

#  it 'returns an image tag' do
#    get '/'
#    assert last_response.ok?
#    assert last_response.body.include?('img')
#  end
end
