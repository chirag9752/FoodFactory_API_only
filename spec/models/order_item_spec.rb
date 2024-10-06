# class OrderItem < ApplicationRecord
#   validates :order_id, :menu_id, :quantity, :price, presence: true
#   belongs_to :order
#   belongs_to :menu
# end

require 'rails_helper'

RSpec.describe OrderItem, type: :model do

  let(:user) { FactoryBot.create(:user) }
  let(:hotel) { FactoryBot.create(:hotel, user: user) }
  let(:menu) { FactoryBot.create(:menu, hotel: hotel) }
  let(:order) { FactoryBot.create(:order, user: user, hotel: hotel) }
  let(:orderItem) {FactoryBot.create(:orderItem, order: order, menu: menu)}
  
  describe "validations" do
    it "is valid with the valid attribute" do
      expect(orderItem).to be_valid
    end

    it "is not valid without orderId" do
      orderItem.order_id = nil
      expect(orderItem).to_not be_valid
    end

    it "is not valid without menu id" do
      orderItem.menu_id = nil
      expect(orderItem).to_not be_valid
    end

    it "is not valid without quantity" do
      orderItem.quantity = nil
      expect(orderItem).to_not be_valid
    end

    it "is not valid without price" do
      orderItem.price = nil
      expect(orderItem).to_not be_valid
    end

  end

  describe 'associations' do
    it { should belong_to(:order) }
    it { should belong_to(:menu) }
  end
end