require 'rails_helper'

RSpec.describe Menu, type: :model do
 
  let(:user) {FactoryBot.create(:user)}
  let(:hotel) {FactoryBot.create(:hotel, user: user)}
  let(:menu) {FactoryBot.create(:menu, hotel: hotel)}
  
  describe "validations" do
    it "should be valid with valid attribute" do
      expect(menu).to be_valid
    end
    
    it "should-not be valid without menu_name attribute" do
      menu.menu_name = nil
      expect(menu).to_not be_valid
    end

    it "should-not be valid without price attribute" do
      menu.price = nil
      expect(menu).to_not be_valid
    end

    it "should-not be valid without hotel_id attribute" do
      menu.hotel_id = nil
      expect(menu).to_not be_valid
    end
  end

  describe "association" do
    it { should belong_to(:hotel)}
    it { should have_many(:order_items).dependent(:destroy)}
  end
end