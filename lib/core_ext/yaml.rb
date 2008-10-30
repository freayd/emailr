module YAML
  # Charge un flux YAML écrit en eRuby.
  def self.erb_load(io)
    self.load(ERB.new(io).result)
  end

  # Charge un document YAML écrit en eRuby.
  def self.erb_load_file(filepath)
    self.load(ERB.new(IO.read(filepath)).result)
  end
end
