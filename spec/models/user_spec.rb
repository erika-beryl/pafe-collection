require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザー登録' do
    it 'name, email, passwordとpassword_confirmationが存在すれば登録できる' do end
    it 'emailがない場合にinvalidになるか' do end
    it 'nameが無い場合にinvalidになるか' do end
    it 'passwordが無い場合にinvalidになるか' do end
    it 'password_confirmationが無い場合にinvalidになるか' do end
    it 'passwordとpassword_confirmationが一致しないとinvalidになるか' do end     
end
