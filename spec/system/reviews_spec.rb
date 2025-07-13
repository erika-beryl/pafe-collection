require 'rails_helper'

RSpec.describe 'Reviews', type: :system do
  let!(:user) { create(:user) }
  let!(:shop) { create(:shop) }
  let!(:parfait) { create(:parfait, shop:shop) }
  let(:review) { create(:review, user:user, parfait:parfait) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'レビューの新規登録ページにアクセス' do
        it '新規登録ページへのアクセスが失敗する' do
          visit new_review_path(parfait_id: parfait.id)
          expect(page).to have_content 'ログインしてください'
          expect(current_path).to eq new_user_session_path
        end
      end

      context 'レビューの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_review_path(parfait)
          expect(page).to have_content 'ログインしてください'
          expect(current_path).to eq new_user_session_path
        end
      end

      context 'レビューの詳細ページにアクセス' do
        it 'パフェの詳細情報が表示される' do
          visit review_path(review)
          expect(page).to have_content review.title
          expect(current_path).to eq review_path(review)
        end
      end

      context 'レビューの一覧ページにアクセス' do
        it 'すべてのパフェの情報が表示される' do
          review_list = create_list(:review, 3)
          visit reviews_path
          expect(page).to have_content review_list[0].title
          expect(page).to have_content review_list[1].title
          expect(page).to have_content review_list[2].title
          expect(current_path).to eq reviews_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'レビュー新規登録' do
      before { visit new_review_path(parfait_id: parfait.id) }

      context 'フォームの入力値が正常' do
        it 'レビューの新規作成が成功する' do
          fill_in 'タイトル', with: 'test_review'
          fill_in 'コメント', with: 'test_comment'
          click_button '登録'
          expect(page).to have_content 'レビューが投稿されました'
          expect(current_path).to eq parfait_path(Review.last.parfait)
        end
      end

      context 'titleが未入力' do
        it 'レビューの新規作成が失敗する' do
          fill_in 'タイトル', with: ''
          fill_in 'コメント', with: 'test_comment'
          click_button '登録'
          expect(page).to have_content 'レビューを作成できませんでした'
          expect(page).to have_content 'タイトルを入力してください'
          expect(current_path).to eq reviews_path
        end
      end

      context 'bodyが500字以上' do
        it 'レビューの新規登録が失敗する' do
          fill_in 'タイトル', with: 'test_review'
          fill_in 'コメント', with: 'a' * 501
          click_button '登録'
          expect(page).to have_content 'レビューを作成できませんでした'
          expect(page).to have_content 'コメントは500文字以内で入力してください'
          expect(current_path).to eq reviews_path
        end
      end
    end

    describe 'レビュー編集' do
      before { visit edit_review_path(review) }

      context 'フォームの入力値が正常' do
        it 'レビューの編集が成功する' do
          fill_in 'タイトル', with: 'updated_title'
          click_button '登録'
          expect(page).to have_content 'updated_title'
          expect(page).to have_content 'レビューが更新されました'
          expect(current_path).to eq parfait_path(review.parfait)
        end
      end

      context 'titleが未入力' do
        it 'レビューの編集が失敗する' do
          fill_in 'タイトル', with: ''
          fill_in 'コメント', with: 'update_body'
          click_button '登録'
          expect(page).to have_content 'タイトルを入力してください'
          expect(page).to have_content 'レビューを更新できませんでした '
          expect(current_path).to eq review_path(review)
        end
      end

      context '他ユーザーのレビュー編集ページにアクセス' do
        let!(:other_user) { create(:user, email: "other_user@example.com") }
        let!(:other_review) { create(:review, user: other_user, parfait: parfait) }

        it '編集ページへのアクセスが失敗する' do
          visit edit_review_path(other_review)
          expect(page).to have_content '他のユーザーのレビューは編集できません'
          expect(current_path).to eq root_path
        end
      end
    end

    describe 'レビュー削除' do
      let!(:review) { create(:review, user: user, parfait: parfait) }

      it 'レビューの削除が成功する' do
        visit reviews_path
        find("#button-delete-#{review.id}").click

        # Selenium環境ではdata-turbo-confirmが動かないので以下の通りに書いてます
        expect(page).to have_content '削除に成功しました'
        expect(page).not_to have_content review.title
      end
    end
  end
end