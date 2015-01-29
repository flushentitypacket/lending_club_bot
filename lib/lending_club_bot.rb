require 'lending_club'
require 'yaml'
require 'loan_with_score'
require 'scorer'

class LendingClubBot

  def start
    load_credentials
    loans = LendingClub.loans
    loans_with_scores = loans.map do |loan|
      LoanWithScore.new(loan, Scorer.score(loan))
    end
    puts loans_with_scores.map(&:score)
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
