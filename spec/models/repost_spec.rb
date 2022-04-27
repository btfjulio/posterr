require 'rails_helper'

RSpec.describe Repost, type: :model do
  subject(:repost) { build(:repost) }

  let(:user) { create(:user) }
  let(:today) { Time.zone.today }

  describe 'associations' do
    it { is_expected.to have_one(:entry) }
    it { is_expected.to belong_to(:post).optional(false) }

    context 'when user post is created' do
      subject(:repost) { create(:repost, :with_user, user: user) }

      it 'creates user repost entry' do
        expect { repost }.to change(user.entries.reposts, :count).by(1)
      end
    end
  end

  describe 'validations' do
    it { is_expected.to be_valid }

    context 'when user exceeds daily entries limit' do
      subject(:repost) do
        create(:repost, :with_user, post: Post.last, user: user, created_at: today)
      end

      it 'raises validation error for user entry' do
        freeze_time do
          create_list(:post, 5, :with_user, user: user, created_at: today)

          expect { repost }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
    end
  end
end
