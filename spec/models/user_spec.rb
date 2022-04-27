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
end
