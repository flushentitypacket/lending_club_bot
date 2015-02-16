require 'sequel'
require 'json'

class Loan < Sequel::Model
  plugin :validation_helpers
  plugin :serialization, :json, :json

  def validate
    super
    validates_presence :json
    validates_type Hash, :json
  end
end
