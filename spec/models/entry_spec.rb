require 'rails_helper'

RSpec.describe Entry, type: :model do
  subject(:entry) { create(:entry, entryable: post, user: user) }

  let(:user) { create(:user) }
  let(:post) { create(:post) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to respond_to(:post) }
  end

  describe 'validations' do
    it { is_expected.to be_valid }

    context 'when entryable is not valid' do
      subject(:entry) { build(:entry, entryable: post, user: user) }

      let(:post) { build(:post, content: '') }

      it { expect(entry).to be_invalid }
    end
  end
end
