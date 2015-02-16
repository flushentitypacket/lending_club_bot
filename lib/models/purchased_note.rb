require 'sequel'

class PurchasedNote < Sequel::Model
  plugin :validation_helpers

  many_to_one :loan

  def validate
    super
    validates_presence [:purchased_at, :loan_id]
  end
end
