require 'rails_helper'

RSpec.describe 'shops', type: :system do
  let!(:user) { create(:user) }
  let(:shop) { create(:shop) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'shopの新規登録ページにアクセス' do
        it '新規登録ページへのアクセス失敗' do
        end
      end

      context 'shopの編集ページにアクセス' do
        it '編集ページへのアクセス失敗' do
        end
      end

      context 'shopの詳細ページにアクセス' do
        it 'shopの詳細情報が表示される' do
        end
      end

      context 'shopの一覧ページへアクセス' do
        it 'すべてのshopの一覧が表示される' do
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }

    describe '店舗新規登録' do
      context 'フォームの入力値が正常' do
        it '新規登録が成功' do
        end
      end

      context 'nameが未入力' do
        it '新規登録が失敗' do
        end
      end

      context '既に使われている店舗名' do
        it '新規登録失敗' do
        end
      end

      context 'postal_codeが未入力' do
        it '新規登録失敗' do
        end
      end

      context 'postal_codeが全角で入力される' do
        it '新規登録失敗' do
        end
      end

      context 'prefecture_codeが未入力' do
        it '新規登録失敗' do
        end
      end

      context 'cityが未入力' do
        it '新規登録失敗' do
        end
      end

      context 'streetが未入力' do
        it '新規登録失敗' do
        end
      end

      context 'telが未入力' do
        it '新規登録失敗' do
        end
      end
    end

    describe 'shopの編集' do
      let!(:shop) { create(:shop, user: user) }
      before do
        visit edit_shop_path(shop)
      end

      context 'nameを変更' do
        it '編集成功' do
        end
      end
    end

    describe 'shopの削除' do
      let!(:shop) { create(:shop, user: user) }

      it 'shopの削除に成功する' do
      end
    end
  end
end

