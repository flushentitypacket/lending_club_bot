require 'lending_club'
require 'yaml'
require 'filter'

class LendingClubBot

  def start
    load_credentials
    loans = LendingClub.loans
    filtered_loans = loans.reject { |loan| Filter.filter?(loan) }
    # purchases = order_loans(filtered_loans)
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
