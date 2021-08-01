require "rails_helper"

RSpec.describe "First test" do
	let(:user) { create :user }

	it "check creates user" do
		expect(user.persisted?).to eq true
	end
end