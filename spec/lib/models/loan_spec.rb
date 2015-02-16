require 'spec_helper'

describe Loan do
  it 'has a valid factory' do
    build(:loan).valid?.must_equal true
  end
end
