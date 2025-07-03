require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe '店舗登録' do
    it '設定したバリデーションが機能しているか' do
      shop = build(:shop)
      expect(shop).to be_valid
      expect(shop.errors).to be_empty
    end

    it 'pngの画像をアタッチできるか' do
      shop_attach = build(:shop, :with_shop_image)
      expect(shop_attach).to be_valid
      expect(shop_attach.errors).to be_empty
    end

    it 'content_typeのバリデーション違反をするとinvalidになるか' do
      shop_invalid_attach = build(:shop, :invalid_shop_image)
      expect(shop_invalid_attach).to be_invalid
      expect(shop_invalid_attach.errors[:shop_image]).to include "有効なメディアファイルではありません"
    end
  end
end
