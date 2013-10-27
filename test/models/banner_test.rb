require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Banner Model" do
  it 'can construct a new instance' do
    @banner = Banner.new
    refute_nil @banner
  end
end
