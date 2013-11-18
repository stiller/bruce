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

  def set key, value
    super(PADRINO_ENV + key, value)
  end

  def expire key, expire
    super(PADRINO_ENV + key, expire)
  end

  def get key
    super(PADRINO_ENV + key)
  end
end
