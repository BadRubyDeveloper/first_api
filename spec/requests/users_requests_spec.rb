require "rails_helper"

RSpec.describe UsersController, type: :request do
	describe "GET /index" do
		let!(:users) { create_list :user, 3 }

		before { get "/users" }

		it "return success" do
			expect(last_response.status).to eq 200
		end

		it "return users collection" do
			expect(response_json).to match parse_json(users)
		end
	end

	describe "POST /create" do
		before do
			post "/users", user: user_params
		end

		context "when user is created" do
			let(:user_params) { { name: "John Smith", email: "john_smith@test.com", password: "1234" } }

			it "return status created" do
				expect(last_response.status).to eq 201
			end

			it "return correct user data" do
				expect(response_json).to match parse_json(User.last)
			end
		end

		context "when user is not created" do
			let(:user_params) { { name: "John Smith" } }

			it "return status bad request" do
				expect(last_response.status).to eq 400
			end

			it "return error data" do
				expect(response_json["message"]).to eq "User not created!"
			end
		end
	end

	describe "GET /users/:id" do
		let(:user) { create :user }

		before do
			get "/users/#{search_id}"
		end

		context "when user exist" do
			let(:search_id) { user.id }

			it "return status 200" do
				expect(last_response.status).to eq 200
			end

			it "return correct data" do
				expect(response_json).to match parse_json(user)
			end
		end

		context "when user is not exist" do
			let(:search_id) { 0 }

			it "return status 404" do
				expect(last_response.status).to eq 404
			end

			it "return error data" do
				expect(response_json['message']).to eq "User is not exist"
			end
		end
	end

	describe "PATCH /users/:id" do
		let(:user) { create :user }

		before do
			patch "/users/#{user.id}", user: user_params
		end

		context "when user successfully updated" do
			let(:user_params) { { name: "John Smith", email: "john_smith@test.com", password: "1234" } }

			it "return status ok" do
				expect(last_response.status).to eq 200
			end

			it "return correct data" do
				expect(response_json['name']).to eq "John Smith"
			end
		end

		context "when user not updated" do
			let(:user_params) { { email: "john_smith"} }

			it "return status bad request" do
				expect(last_response.status).to eq 400
			end

			it "return correct data" do
				expect(response_json['message']).to eq "User is not updated!"
			end
		end
	end

	describe "DELETE /users/:id" do
		let(:user) { create :user }

		before do
			delete "/users/#{user.id}"
		end

		context "when user successfully deleted" do
			it "return status no content" do
				expect(last_response.status).to eq 204
			end
		end
	end
end