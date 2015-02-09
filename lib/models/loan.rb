class Loan < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence :json
  end
end
