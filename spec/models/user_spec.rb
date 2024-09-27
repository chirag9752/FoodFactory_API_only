# require 'rails_helper'

# RSpec.describe User, type: :model do
#   # Testing validations
#   describe "validations" do
#     it { should validate_presence_of(:name)}
#     it { should validate_presence_of(:email)}
#     it { should validate_presence_of(:role)}
#     it { should validate_presence_of(:password)}
#   end

#   # Testing associations
#   describe "associations" do
#     it { should have_many(:hotels).dependent(:destroy) }
#     it { should have_many(:orders).dependent(:destroy) }
#   end

#   # Testing enum for roles 
#   describe "roles" do
#     it "defines the correct roles" do
#       except(User.roles.keys).to contain_excatly("admin", "client", "hotel_owner")
#     end
#   end

#   # Testing callbacks 
#   describe "callbacks" do
#     let(:user) { build(:user) }

#     it "sends welcome email after user is created" do
#       expect(UserMailer).to receive(:welcome_email).with(user).and_return(double(deliver_now: true)) 
#       user.save
#     end
#   end

#   # Testing Devise feature (authentication)
#   describe "devise modules" do
#     let(:user) { create(:user, password: "password123" )}
    
#     it "authenticates a valid user" do
#       authenticated_user = user.valid_password?('password123')
#       except(authenticated_user).to be true
#     end

#     it "does not authenticate with wrong password" do
#       authenticated_user = user.valid_password?('wrongpassword')
#       except(authenticated_user).to be false
#     end
#   end
# end



require 'rails_helper'

RSpec.describe User, type: :model do 
  subject {User.new()}
end