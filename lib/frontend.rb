class Frontend
  def initialize collection
    @collection = collection
  end

  def get_another_value_for current_value
    new_value = @collection.sample
    return new_value if single_unique_element
    return @collection.reject{|element| element == current_value}.sample
  end

  def single_unique_element
    Set.new(@collection).size < 2
  end
end
