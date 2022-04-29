require 'rails_helper'

RSpec.describe Quote, type: :model do
  subject(:quote) { build(:quote) }

  let(:user) { create(:user) }
  let(:today) { Time.zone.today }

  describe 'associations' do
    it { is_expected.to have_one(:entry) }
    it { is_expected.to belong_to(:post).optional(false) }

    context 'when user post is created' do
      subject(:quote) { create(:quote, :with_user, user: user) }

      it 'creates user quote entry' do
        expect { quote }.to change(user.entries.quotes, :count).by(1)
      end
    end
  end

  describe 'validations' do
    it { is_expected.to be_valid }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_most(Post::CONTENT_LENGTH_LIMIT) }

    context 'when user exceeds daily posts limit' do
      subject(:quote) { create(:quote, :with_user, user: user, created_at: today) }

      it 'raises validation error for user entry' do
        freeze_time do
          create_list(:post, 5, :with_user, user: user, created_at: today)

          expect { quote }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end
