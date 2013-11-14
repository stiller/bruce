require File.expand_path(File.dirname(__FILE__) + '/../../lib/frontend.rb')
require 'minitest/autorun'

describe Frontend do
  before do
    @frontend = Frontend.new([:foo,:bar])
  end

  it 'never returns the same object twice for at least two objects' do
    previous = :baz
    4.times do
      new_value = @frontend.get_another_value_for previous
      assert new_value != previous
      previous = new_value
    end
  end
end
