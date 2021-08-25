require 'rails_helper'

RSpec.describe ItemsController, type: :request do
  let!(:user) { create :user }
  let!(:wrong_user) { create :user }

  describe "GET /index" do
    let!(:items) { create_list :item, 3, user: user }

    context "when user exist" do
      before { get "/users/#{user.id}/items" }

      it "return status OK" do
        expect(last_response.status).to eq 200
      end

      it "return items collection of user" do
        expect(response_json).to match parse_json(items)
      end
    end
    
    context "when user exist" do
      before { get "/users/0/items" }

      it "return items collection of user" do
        expect(last_response.status).to eq 404
      end

      it "return error message" do
        expect(response_json['message']).to eq "Record not found"
      end
    end
  end

  describe "GET /show" do
    let!(:item) { create :item, user: user }

    before { get "/users/#{user.id}/items/#{item.id}" }

    it "return status OK" do
      expect(last_response.status).to eq 200
    end

    it "return data of item" do
      expect(response_json).to eq parse_json(item)
    end
  end

  describe "POST /create" do
    let!(:item_params) { { name: "New Item" } }
    let!(:token) { TokensCreator.new(user).call }

    context "when user authenticated" do
      before do
        post "/users/#{user.id}/items", { item: item_params }, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
      end

      it "return status CREATED" do
        expect(last_response.status).to eq 201
      end

      it "return created record" do
        expect(response_json['name']).to eq "New Item"
      end
    end

    context "when user not authenticated" do
      before do
        post "/users/#{user.id}/items", { item: item_params }
      end

      it "return status CREATED" do
        expect(last_response.status).to eq 403
      end

      it "return created record" do
        expect(response_json['message']).to eq "Access denied"
      end
    end
  end

  describe "PATCH /update" do
    let!(:item) { create :item, user: user }
    let!(:item_params) { { name: "Updated item" } }

    before do
      patch "/users/#{user.id}/items/#{item.id}", { item: item_params }, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
    end

    context "when user is creator of item" do
      let!(:token) { TokensCreator.new(user).call }

      it "return status OK" do
        expect(last_response.status).to eq 200
      end

      it "return updated record" do
        expect(response_json['name']).to eq "Updated item"
      end
    end

    context "when user is not creator of item" do
      let!(:token) { TokensCreator.new(wrong_user).call }

      it "return status OK" do
        expect(last_response.status).to eq 403
      end

      it "return updated record" do
        expect(response_json['message']).to eq "Access denied"
      end
    end
  end

  describe "DELETE /destroy" do
    let!(:item) { create :item, user: user }

    before do
      delete "/users/#{user.id}/items/#{item.id}", {}, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
    end

    context "when user is creator of item" do
      let!(:token) { TokensCreator.new(user).call }

      it "return status NO CONTENT" do
        expect(last_response.status).to eq 204
      end
    end
    
    context "when user is not creator of item" do
      let!(:token) { TokensCreator.new(wrong_user).call }

      it "return status OK" do
        expect(last_response.status).to eq 403
      end

      it "return updated record" do
        expect(response_json['message']).to eq "Access denied"
      end
    end
  end
end
