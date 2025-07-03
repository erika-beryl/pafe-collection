require 'rails_helper'

RSpec.describe Bookmark, type: :model do
  let(:review_user) { create(:user) }
  let(:bookmark_user) { create(:user) }

  describe 'ブックマーク' do
    it 'reviewを書いた本人でなければブックマークできる' do
      review = create(:review, user: review_user)
      bookmark = build(:bookmark, review: review, user: bookmark_user)
      expect(bookmark).to be_valid
      expect(bookmark.errors).to be_empty
    end
      
    it 'reviewを書いた本人がブックマークするとエラーになる' do
      review = create(:review, user: review_user)
      bookmark_self = build(:bookmark, review: review, user: review_user)
      expect(bookmark_self).to be_invalid
      expect(bookmark_self.errors[:user_id]).to include "自分のレビューにはブックマークできません"
    end

    it '既にブックマークしてあるレビューにブックマークできない' do
      review = create(:review, user: review_user)
      bookmark = create(:bookmark, review: review, user: bookmark_user)
      bookmark_same = build(:bookmark, review: review, user: bookmark_user)
      expect(bookmark_same).to be_invalid
      expect(bookmark_same.errors[:user_id]).to include "はすでに存在します"
    end
      
  end
end
