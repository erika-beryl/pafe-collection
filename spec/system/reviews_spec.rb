require 'rails_helper'

RSpec.describe 'Parfaits', type: :system do
  let!(:user) { create(:user) }
  let!(:shop) { create(:shop) }
  let!(:parfait) { create(:parfait, shop:shop) }
  let(:review) { create(:review, user:user, parfait:parfait) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'レビューの新規登録ページにアクセス' do
        it '新規登録ページへのアクセスが失敗する' do
        end
      end

      context 'レビューの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do

        end
      end

      context 'レビューの詳細ページにアクセス' do
        it 'パフェの詳細情報が表示される' do
        end
      end

      context 'レビューの一覧ページにアクセス' do
        it 'すべてのパフェの情報が表示される' do
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'レビュー新規登録' do
      context 'フォームの入力値が正常' do
        it 'レビューの新規作成が成功する' do
        end
      end

      context 'titleが未入力' do
        it 'レビューの新規作成が失敗する' do
        end
      end

      context 'bodyが500字以上' do
        it 'レビューの新規登録が失敗する' do
        end
      end
    end

    describe 'レビュー編集' do
      let!(:review) { create(:review, user: user, parfait: parfait) }
      before { visit edit_review_path(review) }

      context 'フォームの入力値が正常' do
        it 'レビューの編集が成功する' do
        end
      end

      context 'titleが未入力' do
        it 'レビューの編集が失敗する' do
        end
      end

      context '他ユーザーのレビュー編集ページにアクセス' do
        let!(:other_user) { create(:user, email: "other_user@example.com") }
        let!(:review) { create(:review, user: other_user, parfait: parfait) }

        it '編集ページへのアクセスが失敗する' do
        end
      end
    end

    describe 'レビュー削除' do
      let!(:review) { create(:review, user: user, parfait: parfait) }

      it 'レビューの削除が成功する' do
      end
    end
  end
end