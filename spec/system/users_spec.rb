require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let(:user) { build(:user) }

  describe 'ユーザー新規登録' do
    context 'フォームの入力値が正常' do
      it 'ユーザーの新規登録が成功する' do
        visit new_user_registration_path
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        fill_in 'パスワード（再入力）', with: user.password_confirmation
        click_button '登録'
        expect(page).to have_content 'ようこそ！ログインに成功しました。'
        expect(current_path).to eq root_path
      end
    end

    context '名前が未入力' do
      it 'ユーザーの新規登録が失敗する' do
        visit new_user_registration_path
        fill_in '名前', with: ''
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        fill_in 'パスワード（再入力）', with: user.password_confirmation
        click_button '登録'
        expect(page).to have_content '名前を入力してください'
        expect(current_path).to eq user_registration_path
      end
    end

    context 'メールアドレスが未入力' do
      it 'ユーザーの新規登録が失敗する' do
        visit new_user_registration_path
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: user.password
        fill_in 'パスワード（再入力）', with: user.password_confirmation
        click_button '登録'
        expect(page).to have_content 'メールアドレスを入力してください'
        expect(current_path).to eq user_registration_path
      end
    end

    context '登録済みのメールアドレスを使用' do
      it 'ユーザーの新規登録が失敗する' do
        existed_user = create(:user)
        visit new_user_registration_path
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: existed_user.email
        fill_in 'パスワード', with: user.password
        fill_in 'パスワード（再入力）', with: user.password_confirmation
        click_button '登録'
        expect(page).to have_content 'メールアドレスはすでに存在します'
        expect(current_path).to eq user_registration_path
      end
    end

    context 'パスワードが未入力' do
      it 'ユーザーの新規登録が失敗する' do
        visit new_user_registration_path
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: ''
        fill_in 'パスワード（再入力）', with: user.password_confirmation
        click_button '登録'
        expect(page).to have_content 'パスワードを入力してください'
        expect(current_path).to eq user_registration_path
      end
    end

    context 'パスワード(再入力)が未入力' do
      it 'ユーザーの新規登録が失敗する' do
        visit new_user_registration_path
        fill_in '名前', with: user.name
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        fill_in 'パスワード（再入力）', with: ''
        click_button '登録'
        expect(page).to have_content 'パスワード（再入力）とパスワードの入力が一致しません'
        expect(page).to have_content 'パスワード（再入力）を入力してください'
        expect(current_path).to eq user_registration_path
      end
    end

  end
end