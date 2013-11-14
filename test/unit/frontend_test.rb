require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

describe Frontend do
  before do
    @frontend = Frontend.new([:foo,:bar])
  end

  it 'never returns the same banner twice for at least two banners' do
    previous = :baz
    4.times do
      new_value = @frontend.get_another_value_for previous
      assert new_value != previous
      previous = new_value
    end
  end
end