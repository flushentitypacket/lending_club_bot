require 'lending_club'
require 'yaml'
require 'loan_with_score'
require 'filter'
require 'scorer'

class LendingClubBot

  def start
    load_credentials
    loans = LendingClub.loans
    filtered_loans = loans.reject { |loan| Filter.filter?(loan) }
    loans_with_scores = filtered_loans.map do |loan|
      LoanWithScore.new(loan, Scorer.score(loan))
    end
    top_loans = loans_with_scores.sort_by(&:score).reverse[0...5]
    top_loans.each do |top_loan|
      puts "score: #{top_loan.score}"
      puts "int_rate: #{top_loan.loan.int_rate}"
      puts "credit score: #{top_loan.loan.fico_range_low}"
      puts "amount: #{top_loan.loan.loan_amount}"
      puts
    end
    puts "number of loans that passed filter: #{filtered_loans.length}"
    # loans_to_buy = loans_with_scores.select do |loan_with_score|
    #   loan_with_score.score > threshold
    # end
    # purchases = order_loans(loans_to_buy)
    # notify(purchases)
  end

  private

  def load_credentials
    YAML.load(File.read('config/credentials.yml')).tap do |credentials|
      LendingClub.access_token = credentials['access_token']
      LendingClub.investor_id = credentials['investor_id']
    end
  end


end
