require 'filter'

class Strategy
  def call(loans)
    purchased_loan_ids = Set.new(
      PurchasedNote.eager(:loan).all.map { |note| note.loan.id })

    loans.
      reject { |loan| Filter.filter?(loan) }.
      reject { |loan|  purchased_loan_ids.include?(loan.id) }
  end
end
