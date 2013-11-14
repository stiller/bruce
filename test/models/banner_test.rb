require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Banner Model" do
  it 'can construct a new instance' do
    @banner = Banner.new
    refute_nil @banner
  end

  it 'is equal when the url is equal' do
    @banner1 = Banner.new(url: 'foo')
    @banner2 = Banner.new(url: 'foo')
    assert @banner1 == @banner2
  end
end
