require 'rails_helper'

RSpec.describe Hotel, type: :model do
  let(:user) {FactoryBot.create(:user)}
  let(:hotel) {FactoryBot.create(:hotel, user: user)}

  describe 'validates' do

    it "should be valid with valid attribute" do
        expect(hotel).to be_valid
    end

    it "should-not be valid without Hotel name attribute" do
      hotel.Hotel_name = nil
      expect(hotel).to_not be_valid
    end

    it "should-not be valid without user_id attribute" do
      hotel.user_id = nil
      expect(hotel).to_not be_valid
    end
  end

  describe "association" do
    it {should have_many(:menus).dependent(:destroy)}
    it {should have_many(:orders)}
    it {should belong_to(:user)}
  end
end