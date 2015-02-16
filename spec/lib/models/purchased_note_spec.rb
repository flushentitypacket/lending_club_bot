require 'spec_helper'

describe PurchasedNote do
  it 'has a valid factory' do
    build(:purchased_note).valid?.must_equal true
  end
end
