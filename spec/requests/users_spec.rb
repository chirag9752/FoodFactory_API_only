require 'rails_helper'

RSpec.describe 'Users API' , type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:admin_user) { FactoryBot.create(:user, :admin) }

  let(:valid_headers) { { 'Authorization' => "Bearer #{generate_jwt_token(user)}" } }
  let(:admin_headers) { { 'Authorization' => "Bearer #{generate_jwt_token(admin_user)}" } }

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

  # Index action
  describe 'GET /users' do
    it 'returns a list of users for an admin' do
      get '/users', headers: admin_headers
      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(User.count)
    end

    it 'returns a 401 status if user is not authenticated' do
      get '/users'
      expect(response).to have_http_status(:unauthorized)
    end
  end
  
  # show action
  describe 'GET /users/:id' do
    it 'returns the current user profile' do
      get "/users/#{user.id}", headers: valid_headers
      expect(response).to have_http_status(:ok)
      expect(json['user']['id']).to eq(user.id)
    end

    it 'returns a 401 status if not authorized' do
      get "/users/#{user.id}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
  
  # update action
  describe 'PUT /users/:id' do
    let(:valid_attributes) { { user: { name: 'New Name', email: user.email, password: user.password } } }

    context 'When authenticated and updating own profile' do
      it 'updates the user successfully' do
        put "/users/#{user.id}", params: valid_attributes, headers: valid_headers
        expect(response).to have_http_status(:ok)
        expect(json['user']['name']).to eq('New Name')
      end

      it 'return error if invalid attributes are provided' do
        put "/users/#{user.id}", params: {user: {email: ''}} , headers: valid_headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['errors']).to include("Email can't be blank")
      end
    end

    context 'when not auntheticated' do 
      it 'return a 401 status' do
        put "/users/#{user.id}", params: valid_attributes

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

