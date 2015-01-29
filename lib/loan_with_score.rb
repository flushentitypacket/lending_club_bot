class LoanWithScore

  attr_reader :loan, :score

  def initialize(loan, score)
    @loan = loan
    @score = score
  end

end
