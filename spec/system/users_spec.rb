require 'rails_helper'

RSpec.describe 'Users', type: system do
  let(:user) { create(:user) }

  describe 'ユーザー新規登録' do
    context 'フォームの入力値が正常' do
      it 'ユーザーの新規登録が成功する' do
      end
    end

    context '名前が未入力' do
      it 'ユーザーの新規登録が失敗する' do
      end
    end

    context 'メールアドレスが未入力' do
      it 'ユーザーの新規登録が失敗する' do
      end
    end

    context '登録済みのメールアドレスを使用' do
      it 'ユーザーの新規登録が失敗する' do
      end
    end

    context 'パスワードが未入力' do
      it 'ユーザーの新規登録が失敗する' do
      end
    end

    context 'パスワード(再入力)が未入力' do
      it 'ユーザーの新規登録が失敗する' do
      end
    end

  end
end