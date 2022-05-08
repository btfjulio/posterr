require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { build(:user) }

  describe 'associations' do
    it { is_expected.to have_many(:entries).dependent(:nullify) }
  end

  describe 'validations' do
    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(User::NAME_LENGTH_LIMIT) }

    context 'when name has invalid characters' do
      before { user.name = '@lPh4Num&R!c' }

      it { is_expected.to be_invalid }
    end
  end

  describe '.follow' do
    subject(:follow) { first_user.follow(second_user) }

    let(:first_user) { create(:user) }
    let(:second_user) { create(:user) }

    it 'creates follow relationships' do
      expect { follow }.to change(first_user.followings, :count).by(1)
        .and change(second_user.followers, :count).by(1)
    end
  end

  describe '.unfollow' do
    subject(:unfollow) { first_user.unfollow(second_user) }

    let(:first_user) { create(:user) }
    let(:second_user) { create(:user) }

    before { first_user.follow(second_user) }

    it 'destroys follow relationships' do
      expect { unfollow }.to change(first_user.followings, :count).by(-1)
        .and change(second_user.followers, :count).by(-1)
    end
  end
end
