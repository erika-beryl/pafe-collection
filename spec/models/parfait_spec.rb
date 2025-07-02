require 'rails_helper'

RSpec.describe Parfait, type: :model do
  describe 'パフェ登録' do
    it '設定したバリデーションが機能しているか' do
      parfait = build(:parfait)
      expect(parfait).to be_valid
      expect(parfait.errors).to be_empty
    end

    it 'name抜きだとinvalidになるか' do
      parfait_without_name = build(:parfait, name: nil)
      expect(parfait_without_name).to be_invalid
      expect(parfait_without_name.errors[:name]).to include "を入力してください"
    end

    it 'nameが100文字いないならvalid' do
      parfait_name_within_100 = build(:parfait, name: 'a' * 100)
      expect(parfait_name_within_100).to be_valid
      expect(parfait_name_within_100.errors).to be_empty
    end

    it 'nameが100文字以上だとinvalid' do
      parfait_name_over_100 = build(:parfait, name: 'a' * 101)
      expect(parfait_name_over_100).to be_invalid
      expect(parfait_name_over_100.errors[:name]).to include "は100文字以内で入力してください"
    end

    it 'body抜きでもvalidになるか' do
      parfait_without_body = build(:parfait, body: nil)
      expect(parfait_without_body).to be_valid
      expect(parfait_without_body.errors).to be_empty
    end

    it 'bodyが500文字以内ならvalid' do
      parfait_body_within_500 = build(:parfait, body: 'a' * 500)
      expect(parfait_body_within_500).to be_valid
      expect(parfait_body_within_500.errors).to be_empty
    end

    it 'bodyが500文字以上だとinvalid' do
      parfait_body_over_500 = build(:parfait, body: 'a' * 501)
      expect(parfait_body_over_500).to be_invalid
      expect(parfait_body_over_500.errors[:body]).to include "は500文字以内で入力してください"
    end

    it 'priceが無い場合invalid' do
      parfait_without_price = build(:parfait, price: nil)
      expect(parfait_without_price).to be_invalid
      expect(parfait_without_price.errors[:price]).to include "を入力してください"
    end

    it 'pngの画像をアタッチできるか' do
      parfait_attach = build(:parfait, :with_parfait_image)
      expect(parfait_attach).to be_valid
      expect(parfait_attach.errors).to be_empty
    end

    it 'content_typeのバリデーション違反をするとinvalidになるか' do
      parfait_invalid_attach = build(:parfait, :invalid_parfait_image)
      expect(parfait_invalid_attach).to be_invalid
      expect(parfait_invalid_attach.errors[:parfait_image]).to include "有効なメディアファイルではありません"
    end
  end
end
