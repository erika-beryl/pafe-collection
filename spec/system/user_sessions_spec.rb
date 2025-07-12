require 'rails_helper'

RSpec.describe 'UserSessions', type: :system do
  let(:user) { create(:user) }

  describe 'ログイン前' do
    context 'フォームの入力値が正常' do
      it 'ログイン処理が成功する' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'Log in'
        expect(page).to have_content 'ログインに成功しました。'
        expect(current_path).to eq root_path
      end
    end

    context 'フォームが未入力' do
      it 'ログイン処理が失敗する' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: user.password
        click_button 'Log in'
        expect(page).to have_content 'メールアドレス またはパスワードが違います'
        expect(current_path).to eq new_user_session_path
      end
    end
  end

  describe 'ログイン後' do
    context 'ログアウトボタンをクリック' do
      it 'ログアウト処理が成功する' do
        login_as(user)
        find('#header-profile').click
        click_link 'ログアウト'
        expect(page).to have_content 'ログイン'
        expect(current_path).to eq root_path
      end
    end
  end
end