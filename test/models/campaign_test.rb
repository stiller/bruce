require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Campaign Model" do
  it 'can construct a new instance' do
    @campaign = Campaign.new
    refute_nil @campaign
  end
end
