require 'rails_helper'

RSpec.describe Follow, type: :model do
  describe 'validations' do
    context 'when user follows the same user twice' do
      subject(:repeated_follow) { build(:follow, follower: first_user, following: second_user) }

      let(:first_user) { create(:user) }
      let(:second_user) { create(:user) }

      before { create(:follow, follower: first_user, following: second_user) }

      it { expect(repeated_follow).to be_invalid }
    end

    context 'when user follows themself' do
      subject(:follow) { build(:follow, follower: first_user, following: first_user) }

      let(:first_user) { create(:user) }

      it { expect(follow).to be_invalid }
    end
  end
end
