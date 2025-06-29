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
      expect(user_without_email.errors[:email]).to eq []
    end
    it 'nameが無い場合にinvalidになるか' do end
    it 'passwordが無い場合にinvalidになるか' do end
    it 'password_confirmationが無い場合にinvalidになるか' do end
    it 'passwordとpassword_confirmationが一致しないとinvalidになるか' do end
    it '同じメールアドレスは登録できない'
    it 'name,email,password,password_confirmationが存在すれば登録できるか' do end      
end
