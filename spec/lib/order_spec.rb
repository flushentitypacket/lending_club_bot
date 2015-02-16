require 'spec_helper'
require 'order'

describe Order do

  describe '#execute!' do
    # TODO
  end

  describe '#dry_run?' do
    it 'defaults to true' do
      Order.new(nil).dry_run?.must_equal true
    end

    it 'is settable as an option at initialize time' do
      order = Order.new(nil, dry_run: false)
      order.dry_run?.must_equal false
      order = Order.new(nil, dry_run: true)
      order.dry_run?.must_equal true
    end
  end

end
