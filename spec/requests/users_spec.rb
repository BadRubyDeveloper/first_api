require "rails_helper"

RSpec.describe UsersController, type: :request do
	describe "GET /index" do
		let!(:current_user) { create :user }
		let!(:role) { Role.create(permission: "admin") }
		let!(:users) { create_list :user, 3 }
		let!(:token) { TokensCreator.new(current_user).call }

		context "when user if admin" do
			let!(:user_role) { create :user_role, user: current_user, role: role }

			before do
				get "/users", {}, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
			end

			it "return status OK" do
				expect(last_response.status).to eq 200
			end

			it "return users collection" do
				users_ids = users.pluck(:id)
				users_ids << current_user.id
				expect(response_json.pluck('id').sort).to match users_ids.sort
			end
		end

		context "when user is not admin" do
			before do
				get "/users", {}, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
			end

			it "return success" do
				expect(last_response.status).to eq 403
			end

			it "return users collection" do
				expect(response_json['message']).to eq "Access denied"
			end
		end

		context "when user not authenticated" do
			let!(:token) { "undefined" }

			before do
				get "/users", {}, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
			end

			it "return success" do
				expect(last_response.status).to eq 403
			end

			it "return users collection" do
				expect(response_json['message']).to eq "Access denied"
			end
		end
	end

	describe "POST /create" do
		before do
			post "/users", user: user_params
		end

		context "when user is created" do
			let!(:user_params) { { name: "John Smith", email: "john_smith@test.com", password: "1234" } }

			it "return status created" do
				expect(last_response.status).to eq 201
			end

			it "return correct user data" do
				expect(response_json).to match parse_json(User.last)
			end

			it 'return encrtypted password' do
				expect(response_json['password']).to eq Base64.encode64("1234")
			end
		end

		context "when user is not created" do
			let(:user_params) { { name: "John Smith", password: "1234" } }

			it "return status bad request" do
				expect(last_response.status).to eq 400
			end

			it "return error data" do
				expect(response_json["message"]).to eq "User not created!"
			end
		end
	end

	describe "GET /users/:id" do
		let!(:current_user) { create :user }
		let!(:user) { create :user }

		context "when user is admin" do
			let!(:role) { create :role, permission: "admin" }
			let!(:user_role) { create :user_role, role: role, user: current_user }
			let!(:token) { TokensCreator.new(current_user).call }

			before do
				get "/users/#{search_id}", {}, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
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
					expect(response_json['message']).to eq "Record not found"
				end
			end
		end

		context "when user is not admin and tries to see himself" do
			let!(:role) { create :role }
			let!(:user_role) { create :user_role, role: role, user: user }
			let!(:token) { TokensCreator.new(user).call }

			before do
				get "/users/#{search_id}", {}, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
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
					expect(response_json['message']).to eq "Record not found"
				end
			end
		end

		context "when user is not admin and tries to see another user" do
			let!(:role) { create :role }
			let!(:user_role) { create :user_role, role: role, user: current_user }
			let!(:token) { TokensCreator.new(current_user).call }

			before do
				get "/users/#{search_id}", {}, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
			end

			context "when user exist" do
				let(:search_id) { user.id }

				it "return status 200" do
					expect(last_response.status).to eq 403
				end

				it "return correct data" do
					expect(response_json['message']).to eq "Access denied"
				end
			end

			context "when user is not exist" do
				let(:search_id) { 0 }

				it "return status 404" do
					expect(last_response.status).to eq 404
				end

				it "return error data" do
					expect(response_json['message']).to eq "Record not found"
				end
			end
		end

		context "when user not authenticated" do
			let!(:token) { "undefined" }

			before do
				get "/users/#{search_id}", {}, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
			end

			context "when user exist" do
				let(:search_id) { user.id }

				it "return status 200" do
					expect(last_response.status).to eq 403
				end

				it "return correct data" do
					expect(response_json['message']).to eq "Access denied"
				end
			end
		end
	end

	describe "PATCH /users/:id" do
		let!(:current_user) { create :user }
		let(:user) { create :user }
		let!(:role) { Role.create(permission: "admin") }
		let!(:token) { TokensCreator.new(current_user).call }

		context "when user is admin" do
			let!(:user_role) { create :user_role, role: role, user: current_user }

			before do
				patch "/users/#{user.id}", { user: user_params }, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
			end

			context "when user successfully updated" do
				let(:user_params) { { name: "John Smith", email: "john_smith@test.com", password: "1234" } }

				it "return status ok" do
					expect(last_response.status).to eq 200
				end

				it "return correct data" do
					expect(response_json['name']).to eq "John Smith"
				end

				it 'return encrtypted password' do
					expect(response_json['password']).to eq Base64.encode64("1234")
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

		context "when user not admin and tries upate himself" do
			let!(:role) { create :role }
			let!(:user_role) { create :user_role, role: role, user: user }
			let!(:token) { TokensCreator.new(user).call }

			before do
				patch "/users/#{user.id}", { user: user_params }, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
			end

			context "when user successfully updated" do
				let(:user_params) { { name: "John Smith", email: "john_smith@test.com", password: "1234" } }

				it "return status ok" do
					expect(last_response.status).to eq 200
				end

				it "return correct data" do
					expect(response_json['name']).to eq "John Smith"
				end

				it 'return encrtypted password' do
					expect(response_json['password']).to eq Base64.encode64("1234")
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

		context "when user is not admin and tries to update another user" do
			let!(:role) { create :role }
			let!(:user_role) { create :user_role, role: role, user: current_user }
			let!(:token) { TokensCreator.new(current_user).call }

			before do
				patch "/users/#{user.id}", { user: user_params }, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
			end

			context "when user successfully updated" do
				let(:user_params) { { name: "John Smith", email: "john_smith@test.com", password: "1234" } }

				it "return status ok" do
					expect(last_response.status).to eq 403
				end

				it "return correct data" do
					expect(response_json['message']).to eq "Access denied"
				end
			end
		end

		context "when user not authenticated" do
			let!(:token) { "undefined" }

			before do
				patch "/users/#{user.id}", { user: user_params }, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
			end

			context "when user successfully updated" do
				let(:user_params) { { name: "John Smith", email: "john_smith@test.com", password: "1234" } }

				it "return status ok" do
					expect(last_response.status).to eq 403
				end

				it "return correct data" do
					expect(response_json['message']).to eq "Access denied"
				end
			end
		end
	end

	describe "DELETE /users/:id" do
		let(:user) { create :user }
		let(:current_user) { create :user }

		context "when user is admin" do
			let!(:role) { create :role, permission: "admin" }
			let!(:user_role) { create :user_role, role: role, user: current_user }
			let!(:token) { TokensCreator.new(current_user).call }

			before do
				delete "/users/#{user.id}", {}, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
			end

			context "when user successfully deleted" do
				it "return status no content" do
					expect(last_response.status).to eq 204
				end
			end
		end

		context "when user not admin and tries to delete himself" do
			let!(:role) { create :role }
			let!(:user_role) { create :user_role, role: role, user: user }
			let!(:token) { TokensCreator.new(user).call }

			before do
				delete "/users/#{user.id}", {}, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
			end

			context "when user successfully deleted" do
				it "return status no content" do
					expect(last_response.status).to eq 403
				end
			end
		end

		context "when user not admin and tries to delete another user" do
			let!(:role) { create :role }
			let!(:user_role) { create :user_role, role: role, user: current_user }
			let!(:token) { TokensCreator.new(current_user).call }

			before do
				delete "/users/#{user.id}", {}, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
			end

			context "when user successfully deleted" do
				it "return status no content" do
					expect(last_response.status).to eq 403
				end
			end
		end

		context "when user not authenticated" do
			let!(:token) { "undefined" }

			before do
				delete "/users/#{user.id}", {}, { "HTTP_AUTHORIZATION" => "Bearer #{token}" }
			end

			context "when user successfully deleted" do
				it "return status no content" do
					expect(last_response.status).to eq 403
				end
			end
		end
	end
end