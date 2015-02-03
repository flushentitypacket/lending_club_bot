require 'filter'

class Strategy
  def call(loans)
    loans.reject { |loan| Filter.filter?(loan) }
  end
end
