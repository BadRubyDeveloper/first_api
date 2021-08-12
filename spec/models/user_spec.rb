require 'rails_helper'

RSpec.describe User, type: :model do
  let(:prepared_user) { build :user }

  it "creates user" do
    prepared_user.save

    expect(prepared_user.persisted?).to eq true
  end

  context "when user data is invalid" do
    let(:prepared_user) { build :user, email: "john", name: nil, password: nil }

    it 'return false value' do
      expect(prepared_user.valid?).to eq false
    end

    it "retrun validarion errors" do
      prepared_user.valid?

      expect(prepared_user.errors.full_messages).to eq [
        "Name can't be blank",
        "Password can't be blank",
        "Email is invalid"
      ]
    end
  end

  context "when user with email already exist" do
    let!(:user) { create :user, email: "john_smith@test.com" }
    let(:second_user) { build :user, email: "john_smith@test.com" }

    it "return false value" do
      expect(second_user.valid?).to eq false
    end
  end
end
