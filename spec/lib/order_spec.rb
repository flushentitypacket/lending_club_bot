# require 'spec_helper'
# require 'order'

# module MockLendingClub
#   class MockLoan
#     attr_reader :id

#     def initialize(id)
#       @id = id
#     end
#   end

#   def order(orders)
#     raise '#order was called without being stubbed'
#   end

#   class Order
#     def initialize(*)
#     end
#   end
# end

# describe Order do

#   describe '#execute!' do
#     let(:id) { 1 }
#     let(:mock_loan) { MockLendingClub::MockLoan.new(id) }

#     describe 'is a dry run' do
#       it 'does not send an order to the API' do
#         Order.new([mock_loan], dry_run: true, client: MockLendingClub).execute!
#       end
#     end

#     describe 'not a dry run' do
#       let(:mock_order) { Minitest::Mock.new }
#       around do |test|
#         MockLendingClub.stub(:order, [mock_order]) do
#           test.call
#         end
#       end

#       describe 'order is not fulfilled' do
#         it 'does not return that order' do
#           mock_order.expect(:fulfilled?, false)
#           Order.new([mock_loan], dry_run: true, client: MockLendingClub).execute!
#         end
#       end
#     end
#   end

#   describe '#dry_run?' do
#     it 'defaults to true' do
#       Order.new(nil).dry_run?.must_equal true
#     end

#     it 'is settable as an option at initialize time' do
#       order = Order.new(nil, dry_run: false)
#       order.dry_run?.must_equal false
#       order = Order.new(nil, dry_run: true)
#       order.dry_run?.must_equal true
#     end
#   end

# end
