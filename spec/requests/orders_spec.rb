require 'rails_helper'

RSpec.describe 'Users API', type: :request do

  let(:user) { FactoryBot.create(:user, :client) }
  let(:hotelOwner) { FactoryBot.create(:user) }
  let(:admin) { FactoryBot.create(:user, :admin) }
  let(:hotel) { FactoryBot.create(:hotel, user: hotelOwner) }
  let(:order) { FactoryBot.create(:order, user: user, hotel: hotel) }
  let(:menu) { FactoryBot.create(:menu, hotel: hotel) }
  let(:menu1) { FactoryBot.create(:menu, hotel: hotel) }
  let(:menu2) { FactoryBot.create(:menu, hotel: hotel) }
  let(:order_params) { { total_price: 100, status: 'pending' }.deep_symbolize_keys }
  let(:orderItem) do
    [
    { menu_id: menu1.id.to_i, quantity: 2.to_i, price: 20.to_f }.deep_symbolize_keys,
    { menu_id: menu2.id.to_i, quantity: 1.to_i, price: 60.to_f }.deep_symbolize_keys
    ]
  end


  let(:valid_headers) { { 'Authorization' => "Bearer #{generate_jwt_token(user)}" } }
  let(:admin_headers) { { 'Authorization' => "Bearer #{generate_jwt_token(admin)}" } }
  let(:hotel_owner_headers) { { 'Authorization' => "Bearer #{generate_jwt_token(hotelOwner)}" } }

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

  describe 'GET #index' do
    context 'When user is not a client' do 
      it 'return all orders for admin' do 
        # sign_in admin
        get "/users/#{admin.id}/hotels/#{hotel.id}/orders", headers: admin_headers
        expect(response).to have_http_status(:ok)
        expect(assigns(:orders)).to eq(Order.all)
      end

      it 'return all orders regarding to particular hotel of hotel_owner' do 
        # sign_in hotelOwner
        get "/users/#{hotelOwner.id}/hotels/#{hotel.id}/orders", headers: hotel_owner_headers
        expect(response).to have_http_status(:ok)
        expect(assigns(:orders)).to eq(hotel.orders)
      end


    end

    context 'when user is a client' do 
      it 'return all orders regarding to particular client' do 
        # sign_in user
        get "/users/#{user.id}/hotels/#{hotel.id}/orders", headers: valid_headers
        expect(response).to have_http_status(:ok)
        expect(assigns(:orders)).to eq(user.orders)
      end
    end

  end


  describe 'GET #show' do 
    it 'returns the order' do
      # sign_in user
      get "/users/#{user.id}/hotels/#{hotel.id}/orders/#{order.id}", headers: valid_headers
      expect(response).to have_http_status(:ok)
      expect(assigns(:order)).to eq(order)
    end

    it 'returns not found if order does not exist ' do
      # sign_in user
      get "/users/#{user.id}/hotels/#{hotel.id}/orders/#{999}", headers: valid_headers
      expect(response).to have_http_status(:not_found)
    end
  end

  # describe 'POST #create' do
  #   context 'with valid parameters' do
  #     it 'creates a new order' do
  #       # sign_in user
  #       post "/users/#{user.id}/hotels/#{hotel.id}/orders",
  #       params: {
  #         order: {
  #           total_price: 252,
  #           status: "done"
  #         },
  #         order_items: [
  #           { menu_id: 83, quantity: 2, price: 126 }
  #         ]
  #       }, headers: valid_headers
  #       # byebug
  #       expect(response).to have_http_status(:created)
  #     end
  #   end

  #   context 'with invalid parameters' do
  #     it 'returns unprocessable entity' do 
  #       # sign_in user
  #       post "/users/#{user.id}/hotels/#{hotel.id}/orders", 
  #       params: { order: { total_price: 100, status: 'pending' }, order_items: [ {"menu_id": 83, "quantity": 2, "price": 126} ] }, headers: valid_headers
  #       expect(response).to have_http_status(:unprocessable_entity)
  #     end
  #   end
  # end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new order and order items' do
        expect(CreateCheckoutService).to receive(:new).with(
                                                          user, 
                                                          hotel, 
                                                          order_params.deep_symbolize_keys, 
                                                          orderItem
                                                        ).and_call_original

        post "/users/#{user.id}/hotels/#{hotel.id}/orders", params: { order: order_params, order_items: orderItem }, headers: valid_headers

        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_order_params) { { total_price: nil, status: nil } }

      it 'returns unprocessable entity with errors' do
        post "/users/#{user.id}/hotels/#{hotel.id}/orders", params: { order: invalid_order_params, order_items: orderItem }, headers: valid_headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors']).to be_present
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when user is authorized' do 
      it 'delete the order' do
        # sign_in user
        delete "/users/#{user.id}/hotels/#{hotel.id}/orders/#{order.id}", headers: valid_headers
        expect(response).to have_http_status(:ok)
        expect(Order.exists?(order.id)).to be_falsey
      end
    end

    context 'when user is not authorized' do
      it 'returns forbidden' do 
        # sign_in admin
        delete "/users/#{user.id}/hotels/#{hotel.id}/orders/#{user.id}", headers: admin_headers
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when order does not exist' do
      it 'returns not found' do
        # sign_in user
        delete "/users/#{user.id}/hotels/#{hotel.id}/orders/#{999}", headers: valid_headers
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end