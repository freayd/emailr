class Hash
  # Applique #merge récursivement.
  def deep_merge(other_hash)
    # From: http://www.ruby-forum.com/topic/142809
    # Author: Stefan Rusterholz
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
    self.merge(other_hash, &merger)
  end

  # Applique #merge! récursivement.
  def deep_merge!(other_hash)
    merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge!(v2, &merger) : v2 }
    self.merge!(other_hash, &merger)
  end
  alias :deep_update :deep_merge!

  # Rassemble les Hash contenus récursivement dans le Hash courant.
  # Les nouvelles clefs sont séparées par des points en cas de récursivité.
  def gather!()
    each do |key, value|
      if value.is_a?(Hash)
        value.gather!
        value.each do |sub_key, sub_value|
          self["#{key}.#{sub_key}"] = sub_value
        end
        delete(key)
      end
    end
  end
end
