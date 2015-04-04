require 'spec_helper'
require 'api'

describe Api do

  describe '#dry_run?' do
    it 'defaults to true' do
      Api.new.dry_run?.must_equal(true)
    end

    it 'can be set to false at initialize time' do
      Api.new(dry_run: false).dry_run?.must_equal(false)
    end
  end

  describe '#execute_orders!' do
    let(:order) { Api::Order.new(1) }
    let(:orders) { [order] }

    module ErrorProneClient
      def self.method_missing?(method_sym, *arguments, &block)
        raise "#{method_sym} called unexpectedly"
      end
    end

    describe 'dry_run' do
      it 'does not attempt any calls to the client' do
        Api.new(dry_run: true, client: ErrorProneClient).execute_orders!(orders)
      end
    end
  end

end
