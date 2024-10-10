require 'rails_helper'

RSpec.describe "RegistrationsControllers", type: :request do
  include Devise::Test::IntegrationHelpers

  let!(:valid_user_params)do
  {
    user: {
      name: "test",
      email: "test@example.com",
      password: "password",
      role: "client"
    }
  }
  end

  let!(:invalid_role_params)do
  {
    user: {
      name: "invalid",
      email: "invalid@example.com",
      password: "password",
      role: "invalid_role"
    }
  }
  end

  let!(:admin_role_params)do
  {
    user: {
      name: "admin",
      email: "admin@example.com",
      password: "password",
      role: "admin"
    }
  }
  end

  describe "POST /users" do 
    context "with valid role" do
      it "returns an error for attempting to assign admin role" do
        post "/signup", params: valid_user_params

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]["code"]).to eq(200)
        expect(json_response["status"]["message"]).to eq("Signed up successfully.")
        expect(json_response["data"]["email"]).to eq("test@example.com")
      end
    end

    context "with invalid role" do
      it "register the user successfully" do
        post "/signup", params: invalid_role_params

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]["message"]).to eq("Invalid role: invalid_role")
      end
    end

    context "with trying to assign admin role" do
      it "returns an error for attempting to assign admin role" do
        post "/signup", params: admin_role_params

        expect(response).to have_http_status(:forbidden)
        json_response = JSON.parse(response.body)
        expect(json_response["status"]["message"]).to eq("Admin role cannot be assigned through registration.")
      end
    end


  end
end