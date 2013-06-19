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

class HashWithPathUpdateJS < Hash

  def console_log(text)
    puts text
  end

  def self.convert_string_keys(hash)
    hash.keys.each do |key|
      if key.class == String
        case hash[key]
        when String, Fixnum, Array
          hash[key.to_sym] = hash.delete(key)
        else
          hash[key.to_sym] = self.convert_string_keys(hash[key])
          hash.delete(key)
        end
      end
    end
    hash
  end

  def path_exists?(path)
    c = V8::Context.new
    preface = File.read('/Users/palfvin/tmp/pivot_table.js.js')
    c['hash'] = self
    c['path'] = path
    c['console_log'] = method(:console_log)
    c.eval(preface)
    c.eval('new HashWithPathUpdate(hash).path_exists(path)')
  end


  def update(path, val, operation = :replace)
    c = V8::Context.new
    preface = File.read('/Users/palfvin/tmp/pivot_table.js.js')
    c['hash'] = self
    c['path'] = path
    c['console_log'] = method(:console_log)
    c['val'] = val
    c['operation'] = operation.to_s
    c.eval(preface)
    results = c.eval("JSON.stringify(new HashWithPathUpdate(hash).update(path, val, operation))")
    self.replace(JSON[results])
    self.class.convert_string_keys(self)
    self
  end

end