module Connection
  def connect(config)
    require "sequel"
    Sequel.connect(config)
  end
end
