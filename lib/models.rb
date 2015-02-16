module Models
  def require_models
    require 'sequel'
    Dir[File.dirname(__FILE__) + '/models/*.rb'].each {|file| require file }
    nil
  end
end
