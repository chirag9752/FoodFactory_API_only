require 'rails_helper'

RSpec.describe HotelsController, type: :request do
  include FactoryBot::Syntax::Methods

  let!(:user) { FactoryBot.create(:user, :client) }
  let!(:admin) { FactoryBot.create(:user, :admin) }
  let!(:hotelowneruser) { FactoryBot.create(:user) }
  # let!(:hotel) { FactoryBot.create(:hotel, user: user) }
  let(:valid_headers) { { 'Authorization' => "Bearer #{generate_jwt_token(user)}" } }
  let(:admin_headers) { { 'Authorization' => "Bearer #{generate_jwt_token(admin)}" } }
  let(:hotel_owner_headers) { { 'Authorization' => "Bearer #{generate_jwt_token(hotelowneruser)}" } }

  # before do
  #   sign_in user # Sign in the user before each test
  # end

  def generate_jwt_token(user)
    post '/login', params: { user: { email: user.email, password: user.password } }
    
    json_response = JSON.parse(response.body)
    # puts "Login response: #{json_response.inspect}"
    
    if json_response['status']['code'] == 200
      json_response['status']['data']['user']['jwt']
    else
      nil
    end
  end

  describe 'GET #index' do 
    context 'when a user is client or admin' do
      it 'return successfull response with hotels' do
        hotels = create_list(:hotel, 3, user: hotelowneruser) # create 3 hotels for the user

        get "/users/#{user.id}/hotels" , headers: valid_headers    #checking by client

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(3) # Check if 3 hotels are returned
      end
    end

    
    context 'When user role is not an admin or client' do
      let!(:another_hotel_owner) { FactoryBot.create(:user) }
      
      it 'return successfull response with hotels' do 
        create_list(:hotel, 2, user: hotelowneruser)
        create_list(:hotel, 2, user: another_hotel_owner)

        get "/users/#{hotelowneruser.id}/hotels", headers: hotel_owner_headers

        expect(JSON.parse(response.body).size).to eq(2)   #check that only 2 hotels created by hotelowner is only shown
      end
    end
  end

  describe 'GET #show' do
    let!(:hotel) { FactoryBot.create(:hotel, user: user) }
    
    it 'return a successfull response for a valid hotel' do
      get "/users/#{user.id}/hotels/#{hotel.id}", headers: valid_headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(hotel.id)
    end

    it 'returns not found for an invalid hotel' do
      get "/users/#{user.id}/hotels/#{8888}", headers: valid_headers

      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Hotel not found')
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do 
      it "create a new hotel" do 
        valid_attributes = {
        hotel: {
        Hotel_name: "BABA JI Hotel"
        }
      }
      
      expect {
              post "/users/#{hotelowneruser.id}/hotels", params: valid_attributes, headers: hotel_owner_headers
            }.to change(Hotel, :count).by(1)


        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['Hotel_name']).to eq('BABA JI Hotel')
      end

    end

    context 'with invalid parameters' do
      it 'return unprocessable entity' do
        invalid_attributes = {
        hotel: {
        Hotel_name: " "
        }
      }
      post "/users/#{hotelowneruser.id}/hotels", params: invalid_attributes, headers: hotel_owner_headers
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)).to have_key('Hotel_name')
      end
    end
  end

  describe 'PUT #update' do 
    let(:hotel) { FactoryBot.create(:hotel, user: hotelowneruser) }
    
    context 'with valid parameters' do 
      it 'updates the hotel' do
        valid_attributes = {hotel: { Hotel_name: 'update Hotel' }}

        put "/users/#{hotelowneruser.id}/hotels/#{hotel.id}",params: valid_attributes, headers: hotel_owner_headers

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['Hotel_name']).to eq('update Hotel')
      end
    end

    context 'with invalid paramters' do 
      it 'returns unprocessable entity' do
        invalid_attributes = { hotel: { Hotel_name: '' } }

        put "/users/#{hotelowneruser.id}/hotels/#{hotel.id}", params: invalid_attributes, headers: hotel_owner_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to have_key('Hotel_name')
      end
    end
  end

  describe 'DELETE #destroy' do 
    let!(:hotel) { FactoryBot.create(:hotel, user: hotelowneruser) }
    it 'delete the hotel' do
      hotel_name = hotel.Hotel_name
      delete "/users/#{hotelowneruser.id}/hotels/#{hotel.id}", headers: hotel_owner_headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)["message"]).to eq("#{hotel_name} hotel was deleted successfully")
    end

    it "return not found for an invalid hotel" do
      delete "/users/#{hotelowneruser.id}/hotels/#{6543}", headers: hotel_owner_headers
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Hotel not found')
    end
  end 

  
end



