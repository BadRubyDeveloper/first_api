require 'rails_helper'

RSpec.describe Item, type: :model do
  let!(:user) { create :user }
  let!(:invalid_item) { build :item, name: nil, user: user }
  let!(:valid_item) { build :item, user: user }

  it "return false value" do
    expect(invalid_item.valid?).to eq false
  end

  it "return true value" do
    expect(valid_item.valid?).to eq true
  end
end
