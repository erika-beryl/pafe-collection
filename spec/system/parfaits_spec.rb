require 'rails_helper'

RSpec.describe 'Parfaits', type: :system do
  let!(:user) { create(:user) }
  let!(:shop) { create(:shop) }
  let(:parfait) { create(:parfait, shop:shop) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'パフェの新規登録ページにアクセス' do
        it '新規登録ページへのアクセスが失敗する' do
          visit new_shop_parfait_path(shop)
          expect(page).to have_content 'ログインしてください'
          expect(current_path).to eq new_user_session_path
        end
      end

      context 'パフェの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_parfait_path(parfait)
          expect(page).to have_content 'ログインしてください'
          expect(current_path).to eq new_user_session_path
        end
      end

      context 'パフェの詳細ページにアクセス' do
        it 'パフェの詳細情報が表示される' do
          visit parfait_path(parfait)
          expect(page).to have_content parfait.name
          expect(current_path).to eq parfait_path(parfait)
        end
      end

      context 'パフェの一覧ページにアクセス' do
        it 'すべてのパフェの情報が表示される' do
          parfait_list = create_list(:parfait, 3)
          visit parfaits_path
          expect(page).to have_content parfait_list[0].name
          expect(page).to have_content parfait_list[1].name
          expect(page).to have_content parfait_list[2].name
          expect(current_path).to eq parfaits_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }
    before { visit new_shop_parfait_path(shop) }
    describe 'パフェ新規登録' do
      context 'フォームの入力値が正常' do
        it 'パフェの新規作成が成功する' do
          fill_in '商品名', with: 'test_parfait'
          select '1,001～1,500円', from: '価格'
          check '期間限定商品でしょうか？'
          fill_in '商品紹介', with: 'testtest'
          click_button '登録'
          expect(page).to have_content 'パフェが登録されました'
          expect(page).to have_content 'test_parfait'
          expect(current_path).to eq parfait_path(Parfait.last)
        end
      end

      context 'nameが未入力' do
        it 'パフェの新規作成が失敗する' do
          fill_in '商品名', with: ''
          select '1,001～1,500円', from: '価格'
          check '期間限定商品でしょうか？'
          fill_in '商品紹介', with: 'testtest'
          click_button '登録'
          expect(page).to have_content 'パフェを作成できませんでした'
          expect(page).to have_content '商品名を入力してください'
          expect(current_path).to eq shop_parfaits_path(shop)
        end
      end

      context 'bodyが500字以上' do
        it 'パフェの新規登録が失敗する' do
          fill_in '商品名', with: 'test'
          select '1,001～1,500円', from: '価格'
          check '期間限定商品でしょうか？'
          fill_in '商品紹介', with: 'a' * 501
          click_button '登録'
          expect(page).to have_content 'パフェを作成できませんでした'
          expect(page).to have_content '商品紹介は500文字以内で入力してください'
          expect(current_path).to eq shop_parfaits_path(shop)
        end
      end

      context 'priceが未入力' do
        it 'パフェの新規登録が失敗する' do
          fill_in '商品名', with: 'test'
          check '期間限定商品でしょうか？'
          fill_in '商品紹介', with: 'testtest'
          click_button '登録'
          expect(page).to have_content 'パフェを作成できませんでした'
          expect(page).to have_content '価格を選択してください'
          expect(current_path).to eq shop_parfaits_path(shop)
        end
      end
    end

    describe 'パフェ編集' do
      let!(:parfait) { create(:parfait, shop: shop) }
      before { visit edit_parfait_path(parfait) }

      context 'フォームの入力値が正常' do
        it 'パフェの編集が成功する' do
          fill_in '商品名', with: 'updated_name'
          click_button '登録'
          expect(page).to have_content 'updated_name'
          expect(current_path).to eq parfait_path(parfait)
        end
      end

      context 'nameが未入力' do
        it 'パフェの編集が失敗する' do
          fill_in '商品名', with: ''
          fill_in '商品紹介', with: 'update_body'
          click_button '登録'
          expect(page).to have_content 'パフェを更新できませんでした'
          expect(page).to have_content '商品名を入力してください'
          expect(current_path).to eq parfait_path(parfait)
        end
      end
    end

    describe 'パフェ削除' do
      let!(:parfait) { create(:parfait, shop: shop) }

      it 'パフェの削除が成功する' do
        visit parfaits_path
        find("#button-delete-#{parfait.id}").click

        # Selenium環境ではdata-turbo-confirmが動かないので以下の通りに書いてます
        expect(page).to have_content '削除に成功しました'
        expect(page).not_to have_content parfait.name
      end
    end
  end
end