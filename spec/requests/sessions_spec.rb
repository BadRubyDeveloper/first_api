require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  describe "POST /create" do
    let!(:user) { create :user, email: "john_smith@test.com" }

    before do
      post "/sessions", login_data: login_data
    end

    context "when password is right" do
      let(:login_data) { { email: "john_smith@test.com", password: "1234" } }

      it "return status CREATED" do
        expect(last_response.status).to eq 201
      end

      it "return token" do
        decoded_token = JWT.decode response_json['token'], nil, false
        expect(decoded_token.first["email"]).to eq "john_smith@test.com"
      end
    end

    context "when password is wrong" do
      let(:login_data) { { email: "john_smith@test.com", password: "2341" } }

      it "return status CREATED" do
        expect(last_response.status).to eq 400
      end

      it "return token" do
        expect(response_json['message']).to eq "Email or Password is wrong"
      end
    end
  end
end
