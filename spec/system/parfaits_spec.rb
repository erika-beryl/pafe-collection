require 'rails_helper'

RSpec.describe 'Parfaits', type: :system do
  let!(:user) { create(:user) }
  let!(:shop) { create(:shop) }
  let(:parfait) { create(:parfait, shop:shop) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'パフェの新規登録ページにアクセス' do
        it '新規登録ページへのアクセスが失敗する' do
        end
      end

      context 'パフェの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do

        end
      end

      context 'パフェの詳細ページにアクセス' do
        it 'パフェの詳細情報が表示される' do
        end
      end

      context 'パフェの一覧ページにアクセス' do
        it 'すべてのパフェの情報が表示される' do
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe 'パフェ新規登録' do
      context 'フォームの入力値が正常' do
        it 'パフェの新規作成が成功する' do
        end
      end

      context 'nameが未入力' do
        it 'パフェの新規作成が失敗する' do
        end
      end

      context 'bodyが未入力' do
        it 'パフェの新規登録が失敗する' do
        end
      end

      context 'priceが未入力' do
        it 'パフェの新規登録が失敗する' do
        end
      end
    end

    describe 'パフェ編集' do
      let!(:parfait) { create(:parfait, user: user) }
      before { visit edit_parfait_path(parfait) }

      context 'フォームの入力値が正常' do
        it 'パフェの編集が成功する' do
        end
      end

      context 'nameが未入力' do
        it 'パフェの編集が失敗する' do
        end
      end
    end

    describe 'パフェ削除' do
      let!(:parfait) { create(:parfait, shop: shop) }

      it 'パフェの削除が成功する' do
      end
    end
  end
end