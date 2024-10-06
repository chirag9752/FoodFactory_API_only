require 'rails_helper'

RSpec.describe User, type: :model do 

  before do
    @user = FactoryBot.build(:user)
  end
  
  describe 'validations' do

    it "is valid with a valid attributes" do
      expect(@user).to be_valid
    end
  
    it "is not valid without a role attribute" do
      @user.role = nil
      expect(@user).to_not be_valid
    end
  
    it "is not valid without a password attribute" do
      @user.password = nil
      expect(@user).to_not be_valid
    end
  
    it "is not valid without a email attribute" do
      @user.email = nil
      expect(@user).to_not be_valid
    end
  
    it "is not valid without a name attribute" do
      @user.name = nil
      expect(@user).to_not be_valid
    end
  end

  describe 'roles' do 

    it 'can have an admin role' do
      @user.role = 'admin'
      expect(@user).to be_valid
    end

    it 'can have an client role' do
      @user.role = 'client'
      expect(@user).to be_valid
    end

    it 'can have a hotel_owner role' do
      @user.role = 'hotel_owner'
      expect(@user).to be_valid
    end
    
  end

  # include ActiveJob::Testhelper to test background jobs
  include ActiveJob::TestHelper

  describe 'callbacks' do
    it 'enqueues a welcome email job after creating a user' do
      # clear any previous enqueues jobs
      clear_enqueued_jobs
      user = FactoryBot.create(:user)
      expect(UserMailerJob).to have_been_enqueued.with(user)
    end
  end
end

RSpec.describe 'User Registration', type: :request do
  it 'register a new user' do
    post '/signup', params: {
      user: {
        name: 'test',
        email: 'test@example.com',
        role: 'hotel_owner',
        password: 'password123',
        password_confirmation: 'password123'
      }
    }

    expect(response).to have_http_status(:success)
    expect(User.last.email).to eq('test@example.com')
  end
end

RSpec.describe 'User Login', type: :request do
  let!(:user) { FactoryBot.create(:user) }

  it 'logs in the user and return a JWT token' do
    post '/login', params: {
      user: {
        email: user.email,
        password: 'password'
      }
    }
  expect(response).to have_http_status(:success)
  expect(response.headers['Authorization']).to be_present
  end
end

# Testing JWT Authetication and revocation
RSpec.describe 'JWT Authntication', type: :request do
  let!(:user) { FactoryBot.create(:user) }

  it 'revokes the jwt token on logout' do
    post '/login', params: {
      user: {
        email: user.email,
        password: 'password'
      }
    }

    token = response.headers['Authorization']

    delete '/logout', headers: {
      Authorization: token
    }

    expect(response).to have_http_status(:success)
  end
end


RSpec.describe User, type: :model do
  it { should have_many(:hotels).dependent(:destroy) }
  it { should have_many(:orders).dependent(:destroy) }       

  let!(:user) {FactoryBot.create(:user)}
  let!(:hotel) {FactoryBot.create(:hotel, user: user)}
  let!(:order) {FactoryBot.create(:order, user: user, hotel: hotel)}

  context 'dependent: :destroy' do
    it 'destroy associated hotel when user is destroy' do 
      expect {user.destroy}.to change {Hotel.count}.by(-1)
    end

    it 'destroy associated order when user is destroy' do
      expect {user.destroy}.to change {Order.count}.by(-1)
    end
  end
end