require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'レビュー投稿' do
    it '設定したバリデーションが機能しているか' do
      review = build(:review)
      expect(review).to be_valid
      expect(review.errors).to be_empty
    end

    it 'title抜きだとinvalidになるか' do
      review_without_title = build(:review, title: nil)
      expect(review_without_title).to be_invalid
      expect(review_without_title.errors[:title]).to include "を入力してください"
    end

    it 'titleが100文字いないならvalid' do
      review_title_within_100 = build(:review, title: 'a' * 100)
      expect(review_title_within_100).to be_valid
      expect(review_title_within_100.errors).to be_empty
    end

    it 'titleが100文字以上だとinvalid' do
      review_title_over_100 = build(:review, title: 'a' * 101)
      expect(review_title_over_100).to be_invalid
      expect(review_title_over_100.errors[:title]).to include "は100文字以内で入力してください"
    end

    it 'body抜きだとinvalidになるか' do
      review_without_body = build(:review, body: nil)
      expect(review_without_body).to be_invalid
      expect(review_without_body.errors[:body]).to include "を入力してください"
    end

    it 'bodyが500文字以内ならvalid' do
      review_body_within_500 = build(:review, body: 'a' * 500)
      expect(review_body_within_500).to be_valid
      expect(review_body_within_500.errors).to be_empty
    end

    it 'bodyが500文字以上だとinvalid' do
      review_body_over_500 = build(:review, body: 'a' * 501)
      expect(review_body_over_500).to be_invalid
      expect(review_body_over_500.errors[:body]).to include "は500文字以内で入力してください"
    end

    it 'pngの画像をアタッチできるか' do
      review_attach = build(:review, :with_review_image)
      expect(review_attach).to be_valid
      expect(review_attach.errors).to be_empty
    end

    it 'content_typeのバリデーション違反をするとinvalidになるか' do
      review_invalid_attach = build(:review, :invalid_review_image)
      expect(review_invalid_attach).to be_invalid
      expect(review_invalid_attach.errors[:review_images]).to include "有効なメディアファイルではありません"
    end
  end
end
