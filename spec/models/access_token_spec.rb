require 'rails_helper'

RSpec.describe AccessToken, type: :model do
  describe '#validations' do
    it 'should have a valid factory' do
      expect(build :access_token).to be_valid
    end

    it 'should validate presence of a user' do
      user = build :access_token, user: nil
      expect(user).not_to be_valid
    end
    it 'should validate token' do

    end
  end

  describe '#new' do
    it 'should have a token after initialization' do
      expect(AccessToken.new.token).to be_present
    end

    it 'should generate a uniq token' do
      user = create :user
      expect{ user.create_access_token }.to change{ AccessToken.count }.by(1)
      expect(user.build_access_token).to be_valid
    end

    it 'should generate the token only once' do
      user = create :user
      access_token = user.create_access_token
      expect(access_token.token).to eq(access_token.reload.token)
    end
  end
end
