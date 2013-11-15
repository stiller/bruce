require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe "Selection Model" do
  it 'can construct a new instance' do
    @selection = Selection.new
    refute_nil @selection
  end
end
