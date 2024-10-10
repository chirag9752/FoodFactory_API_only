require "rails_helper"

RSpec.describe 'SessionsController', type: :request do
  include Devise::Test::IntegrationHelpers
  include Rack::Test::Methods

  let!(:user) { create(:user, email: 'test@example.com', password: 'password') }
  let!(:valid_user_params) do
    {
      user: {
        email: user.email,
        password: "password"
      }
    }
  end

  describe 'POST /login' do
    context "with valid credentials" do
      it "logs in the user and return the jwt token" do
        post "/login", params: valid_user_params

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]["code"]).to eq(200)
        expect(json_response["status"]["message"]).to eq("Logged in successfully")
        expect(json_response["status"]["data"]["user"]["email"]).to eq(user.email)
        expect(json_response["status"]["data"]["user"]).to have_key('jwt')
      end
    end

    context "with invalid credentials" do
      it "return unauthorized status with error message" do
        post "/login", params: {user: { email: user.email, password: 'wrong_password'}}

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]["code"]).to eq(401)
        expect(json_response["status"]["message"]).to eq("Invalid email or password")
      end
    end
  end

  describe "Delete /logout" do
    context "with valid token" do
      it "logout the user successfully" do
        post "/login", params: { user: { email: user.email, password: "password" } }

        json_response = JSON.parse(response.body)
        token = json_response['status']['data']['user']['jwt']

        delete "/logout", headers: { 'Authorization' => "Bearer #{token}" }

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq(200)
        expect(json_response['message']).to eq('Logged out successfully')
      end
    end

    context "with invalid or missing token" do
      it 'returns an unauthorized status when no token is provided' do
        delete "/logout", headers:{}

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['status']['message']).to eq("Couldn't find an active session.")
      end

      it 'returns an unauthorized status for an invalid token' do
        delete "/logout", headers: { 'Authorization' => "Bearer #{"invalid_token"}" }

        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)['status']['message']).to eq("Invalid token or user already logged out.")
      end
    end
  end
end