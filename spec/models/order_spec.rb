require 'rails_helper'

RSpec.describe Order, type: :model do
  
  let(:user) { FactoryBot.create(:user) }
  let(:hotel) { FactoryBot.create(:hotel, user: user) }
  let(:order) { FactoryBot.build(:order, user: user, hotel: hotel) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(order).to be_valid
    end

    it 'is not valid without a user' do
      order.user_id = nil
      expect(order).to_not be_valid
    end

    it 'is not valid without a hotel' do
      order.hotel_id = nil
      expect(order).to_not be_valid
    end

    it 'is not valid without a total_price' do
      order.total_price = nil
      expect(order).to_not be_valid
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:hotel) }
    it { should have_many(:order_items).dependent(:destroy) }
  end
end
