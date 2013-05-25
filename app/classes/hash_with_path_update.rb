class HashWithPathUpdate < Hash

  SEP_CHAR = '.'

  def update(path, val, operation = :replace)
    keys = path.split(SEP_CHAR).collect {|k| k.to_sym}
    h = self
    keys[0...-1].each do |key|
      h[key] = {} if !h.key?(key)
      h = h[key]
    end
    if operation == :append and h.key?(keys[-1])
      h[keys[-1]] << val
    else
      h[keys[-1]] = val
    end
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