class HashWithPathUpdate < Hash

  SEP_CHAR = '.'

  def update(path, val)
    keys = path.split(SEP_CHAR).collect {|k| k.to_sym}
    last_key_index = keys.length-1
    h = self
    (0...last_key_index).each do |i|
      key = keys[i]
      h[key] = {} if !h.key?(key)
      h = h[key]
    end
    h[keys[last_key_index]] = val
    self
  end

  def path_exists?(path)
    keys = path.split(SEP_CHAR).collect {|k| k.to_sym}
    h = self
    keys.each do |key|
      if h.is_a?(Hash) && h.key?(key)
        h = h[key]
      else
        return false
      end
    end
    return true
  end

end