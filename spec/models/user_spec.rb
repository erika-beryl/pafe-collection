require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー登録' do
    it '設定したバリデーションが機能しているか' do
      user = build(:user)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it 'emailがない場合にinvalidになるか' do
      user_without_email = build(:user, email: nil)
      expect(user_without_email).to be_invalid
      expect(user_without_email.errors[:email]).to include "を入力してください"
    end

    it 'nameが無い場合にinvalidになるか' do
      user_without_name = build(:user, name: nil)
      expect(user_without_name).to be_invalid
      expect(user_without_name.errors[:name]).to include "を入力してください"
    end

    it 'passwordが無い場合にinvalidになるか' do
      user_without_password = build(:user, password: nil)
      expect(user_without_password).to be_invalid
      expect(user_without_password.errors[:password]).to include "を入力してください"
    end

    it 'password_confirmationが無い場合にinvalidになるか' do
      user_without_password_confirmation = build(:user, password_confirmation: nil)
      expect(user_without_password_confirmation).to be_invalid
      expect(user_without_password_confirmation.errors[:password_confirmation]).to include "を入力してください"
    end

    it 'passwordとpassword_confirmationが一致しないとinvalidになるか' do
      user_difficult_password_confirmation = build(:user, password_confirmation: "passpass")
      expect(user_difficult_password_confirmation).to be_invalid
      expect(user_difficult_password_confirmation.errors[:password_confirmation]).to include "とパスワードの入力が一致しません"
    end

    it '同じメールアドレスは登録できない'do
      user = create(:user)
      user_same = build(:user, email: user.email)
      expect(user_same).to be_invalid
      expect(user_same.errors[:email]).to include "はすでに存在します"
    end

    it 'pngの画像をアタッチできるか' do
      user = build(:user, :with_avatar)
      expect(user).to be_valid
      expect(user.errors).to be_empty
    end

    it 'content_typeのバリデーション違反をするとinvalidになるか' do
      user = build(:user, :invalid_avatar)
      expect(user).to be_invalid
      expect(user.errors[:avatar]).to include "有効なメディアファイルではありません"
    end
  end     
end
