class Frontend
  def get_another_value_for current_value, collection
    new_value = collection.sample
    return new_value if single_unique_element_in collection
    return collection.reject{|element| element == current_value}.sample
  end

  def single_unique_element_in collection
    Set.new(collection).size < 2
  end
end
