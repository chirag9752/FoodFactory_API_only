require "rails_helper"

RSpec.describe OrderItemsController, type: :request do
  let!(:user) { FactoryBot.create(:user) }
  let(:hotel) { FactoryBot.create(:hotel, user: user) }
  let(:order) { FactoryBot.create(:order, user: user, hotel: hotel) }
  let(:menu) { FactoryBot.create(:menu, hotel: hotel) }
  let(:orderItem) { FactoryBot.create(:orderItem, order: order, menu: menu ) }
  let(:valid_headers) { { 'Authorization' => "Bearer #{generate_jwt_token(user)}" } }

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

  describe "GET #index" do
    it "return the orderItem list" do
      get "/users/#{user.id}/hotels/#{hotel.id}/orders/#{order.id}/order_items", headers: valid_headers

      expect(response).to have_http_status(:ok)
    end
  end
end
