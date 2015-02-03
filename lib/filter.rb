class Filter
  def self.filter?(loan)
    loan.fico_range_low < 690 ||
    loan.delinq2_yrs > 0 ||
    loan.dti > 15.0 ||
    loan.loan_amount > 20_000 ||
    (loan.revol_bal / loan.loan_amount) > 0.5 ||
    loan.int_rate < 12.0
    # loan.bought? # Idea for future filter to prevent repeated
    #              # purchasing of the same note
  end
end
