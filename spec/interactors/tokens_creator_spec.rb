require "rails_helper"

RSpec.describe TokensCreator do
	let!(:user) { create :user, email: "john_smith@test.com" }
	let!(:generator) { TokensCreator.new(user) }

	it 'return generated token' do
		created_token = generator.call
		decoded_token = JWT.decode created_token, nil, false

		expect(decoded_token.first["email"]).to eq user.email
	end
end