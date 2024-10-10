require 'rails_helper'

RSpec.describe MenusController, type: :request do 
  let!(:user) { FactoryBot.create(:user, :client) }
  let!(:admin) { FactoryBot.create(:user, :admin) }
  let!(:hotelowner) { FactoryBot.create(:user) }
  let!(:hotel2) { FactoryBot.create(:hotel, user: hotelowner) }
  let!(:hotel1) { FactoryBot.create(:hotel, user: hotelowner) }
  let!(:menu1) { FactoryBot.create(:menu, hotel: hotel1) }
  let!(:menu2) { FactoryBot.create(:menu, hotel: hotel1) }
  let!(:menu3) { FactoryBot.create(:menu, hotel: hotel2) }
  let(:valid_headers) { { 'Authorization' => "Bearer #{generate_jwt_token(user)}" } }
  let(:admin_headers) { { 'Authorization' => "Bearer #{generate_jwt_token(admin)}" } }
  let(:hotel_owner_headers) { { 'Authorization' => "Bearer #{generate_jwt_token(hotelowner)}" } }

  def generate_jwt_token(user)
    post '/login', params: { user: { email: user.email, password: user.password } }
    
    json_response = JSON.parse(response.body)
    # puts "Login respone: #{json_response.inspect}"
    
    if json_response['status']['code'] == 200
      json_response['status']['data']['user']['jwt']
    else
      nil
    end
  end
  
  describe "GET #index" do
     

    context "When user is client or admin" do
      it "return list of all menus associated in foodFactory" do

        get "/users/#{admin.id}/hotels/#{hotel1.id}/menus", headers: admin_headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(3)
      end
    end

    context "When user is hotel_owner" do 
      it "return list of all menus related to particular hotels" do
        get "/users/#{hotelowner.id}/hotels/#{hotel1.id}/menus", headers: hotel_owner_headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(2)
      end
    end

  end

  describe "GET #show" do 
    it "return particular menu" do
      get "/users/#{user.id}/hotels/#{hotel1.id}/menus/#{menu1.id}", headers: valid_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(menu1.id)
    end

    it "return not found when invalid id" do 
      get "/users/#{user.id}/hotels/#{hotel1.id}/menus/#{45654}", headers: valid_headers
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Menu not found')
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "create a new menu" do
        post "/users/#{hotelowner.id}/hotels/#{hotel1.id}/menus",
                                                                params: {
                                                                  menu: {
                                                                    menu_name: "halwa",
                                                                    description: "big with full loaded sugar coted bread",
                                                                    price: 50
                                                                  }
                                                                } , headers: hotel_owner_headers
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['menu_name']).to eq('halwa')
      end
    end

    context "with invalid parameters" do
      it "return a unprocessable entity" do
        post "/users/#{hotelowner.id}/hotels/#{hotel1.id}/menus",
                                                                params: {
                                                                  menu: {
                                                                    menu_name: " ",
                                                                    description: "big with full loaded sugar coted bread",
                                                                    price: 50
                                                                  }
                                                                } , headers: hotel_owner_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('menu_name')
      end
    end
  end

  describe "PUT #update" do
    context "with valid parameters" do
      it "successfully update the menu" do
        valid_attributes = {menu: { menu_name: "burger fry", description: "big with full loaded cream", price: 50 }}
        
        put "/users/#{hotelowner.id}/hotels/#{hotel1.id}/menus/#{menu1.id}", params: valid_attributes, headers: hotel_owner_headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)["menu_name"]).to eq("burger fry")
      end
    end

    context "with invalid parameters" do
      it "returns unprocessable entity" do
        invalid_attributes = {menu: { menu_name: " ", description: "big with full loaded cream", price: 50 }}

        put "/users/#{hotelowner.id}/hotels/#{hotel1.id}/menus/#{menu1.id}", params: invalid_attributes, headers: hotel_owner_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key("menu_name")
      end
    end
  end

  describe "delete #destroy" do
    it "delete the menu" do
      menu_name = menu1.menu_name
      delete "/users/#{hotelowner.id}/hotels/#{hotel1.id}/menus/#{menu1.id}", headers: hotel_owner_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("#{menu_name} is deleted successfully")
    end

    it "return not found for an invalid menu" do
      delete "/users/#{hotelowner.id}/hotels/#{hotel1.id}/menus/#{654345}", headers: hotel_owner_headers
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)["error"]).to eq("Menu not found")
    end
  end

end
