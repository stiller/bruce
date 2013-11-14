class RedisClient < Redis
  def cache(key, expire=nil)
    if (value = get(key)).nil?
      value = yield(self)
      set(key, value.to_json)
      expire(key, expire) if expire
      value
    else
      JSON.parse(value)
    end
  end

  def fetch_for key
    if (value = get(key))
      JSON.parse(value)
    end
  end

  def save_for key, object
    set(key,object.to_json)
  end
end
