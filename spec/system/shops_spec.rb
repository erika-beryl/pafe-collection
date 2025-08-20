require 'rails_helper'

RSpec.describe 'shops', type: :system do
  let!(:user) { create(:user) }
  let!(:payments) do
    %w[カード可 電子マネー可 QRコード決済可].map do |name|
      create(:payment, method_type: name)
    end
  end

  #traitがfactorybotの予約語なのでこちらに直接入力
  let!(:features) do
    %w[景色がよい ファミリー向け カウンター席有り].map do |name|
      Feature.create!(trait: name)
    end
  end

  let(:shop) { create(:shop) }

  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'shopの新規登録ページにアクセス' do
        it '新規登録ページへのアクセス失敗' do
          visit new_shop_path
          expect(page).to have_content 'ログインしてください'
          expect(current_path).to eq new_user_session_path
        end
      end

      context 'shopの編集ページにアクセス' do
        it '編集ページへのアクセス失敗' do
          visit edit_shop_path(shop)
          expect(page).to have_content 'ログインしてください'
          expect(current_path).to eq new_user_session_path
        end
      end

      context 'shopの詳細ページにアクセス' do
        it 'shopの詳細情報が表示される' do
          visit shop_path(shop)
          expect(page).to have_content shop.name
          expect(current_path).to eq shop_path(shop)
        end
      end

      context 'shopの一覧ページへアクセス' do
        it 'すべてのshopの一覧が表示される' do
          shop_list = create_list(:shop, 3)
          visit shops_path
          expect(page).to have_content shop_list[0].name
          expect(page).to have_content shop_list[1].name
          expect(page).to have_content shop_list[2].name
          expect(current_path).to eq shops_path
        end
      end
    end
  end

  describe 'ログイン後' do
    before { login_as(user) }
    before { visit new_shop_path }

    describe '店舗新規登録' do
      context 'フォームの入力値が正常' do
        it '新規登録が成功' do
          fill_in '店舗名', with: 'test_name'
          fill_in '郵便番号', with: '1234567'
          select '東京都', from: '都道府県'
          fill_in '市町村', with: 'テスト市'
          fill_in '番地', with: 'テスト町'
          fill_in 'その他建物など', with: 'testes'
          fill_in '電話番号', with: '0120117117'
          fill_in '営業時間', with: '休：月・火'
          check '予約は可能でしょうか？'
          check '駐車場はありますか？'
          check 'カード可'
          check '景色がよい'
          click_button '登録'
          expect(page).to have_content 'test_name'
          expect(page).to have_content '営業時間 休：月・火'
          expect(current_path).to eq shop_path(Shop.last)
        end
      end

      context 'nameが未入力' do
        it '新規登録が失敗' do
          fill_in '店舗名', with: ''
          fill_in '郵便番号', with: '1234567'
          select '東京都', from: '都道府県'
          fill_in '市町村', with: 'テスト市'
          fill_in '番地', with: 'テスト町'
          fill_in 'その他建物など', with: 'testes'
          fill_in '電話番号', with: '0120117117'
          fill_in '営業時間', with: '休：月・火'
          check '予約は可能でしょうか？'
          check '駐車場はありますか？'
          check 'カード可'
          check '景色がよい'
          click_button '登録'
          expect(page).to have_content '店舗を作成できませんでした'
          expect(page).to have_content '店舗名を入力してください'
          expect(current_path).to eq shops_path
        end
      end

      context '既に使われている店舗名' do
        it '新規登録失敗' do
          other_shop = create(:shop)
          fill_in '店舗名', with: other_shop.name
          fill_in '郵便番号', with: '1234567'
          select '東京都', from: '都道府県'
          fill_in '市町村', with: 'テスト市'
          fill_in '番地', with: 'テスト町'
          fill_in 'その他建物など', with: 'testes'
          fill_in '電話番号', with: '0120117117'
          fill_in '営業時間', with: '休：月・火'
          check '予約は可能でしょうか？'
          check '駐車場はありますか？'
          check 'カード可'
          check '景色がよい'
          click_button '登録'
          expect(page).to have_content '店舗を作成できませんでした'
          expect(page).to have_content '店舗名はすでに使われています'
          expect(current_path).to eq shops_path
        end
      end

      context 'postal_codeが未入力' do
        it '新規登録失敗' do
          fill_in '店舗名', with: 'test_shop'
          fill_in '郵便番号', with: ''
          select '東京都', from: '都道府県'
          fill_in '市町村', with: 'テスト市'
          fill_in '番地', with: 'テスト町'
          fill_in 'その他建物など', with: 'testes'
          fill_in '電話番号', with: '0120117117'
          fill_in '営業時間', with: '休：月・火'
          check '予約は可能でしょうか？'
          check '駐車場はありますか？'
          check 'カード可'
          check '景色がよい'
          click_button '登録'
          expect(page).to have_content '店舗を作成できませんでした'
          expect(page).to have_content '郵便番号を入力してください'
          expect(current_path).to eq shops_path
        end
      end

      context 'postal_codeが全角で入力される' do
        it '新規登録失敗' do
          fill_in '店舗名', with: 'test_shop'
          fill_in '郵便番号', with: '１２３４５６７'
          select '東京都', from: '都道府県'
          fill_in '市町村', with: 'テスト市'
          fill_in '番地', with: 'テスト町'
          fill_in 'その他建物など', with: 'testes'
          fill_in '電話番号', with: '0120117117'
          fill_in '営業時間', with: '休：月・火'
          check '予約は可能でしょうか？'
          check '駐車場はありますか？'
          check 'カード可'
          check '景色がよい'
          click_button '登録'
          expect(page).to have_content '店舗を作成できませんでした'
          expect(page).to have_content '郵便番号は7桁の半角数字で入力してください'
          expect(current_path).to eq shops_path
        end
      end

      context 'prefecture_codeが未入力' do
        it '新規登録失敗' do
          fill_in '店舗名', with: 'test_shop'
          fill_in '郵便番号', with: '1234567'
          fill_in '市町村', with: 'テスト市'
          fill_in '番地', with: 'テスト町'
          fill_in 'その他建物など', with: 'testes'
          fill_in '電話番号', with: '0120117117'
          fill_in '営業時間', with: '休：月・火'
          check '予約は可能でしょうか？'
          check '駐車場はありますか？'
          check 'カード可'
          check '景色がよい'
          click_button '登録'
          expect(page).to have_content '店舗を作成できませんでした'
          expect(page).to have_content '都道府県を入力してください'
          expect(current_path).to eq shops_path
        end
      end

      context 'cityが未入力' do
        it '新規登録失敗' do
          fill_in '店舗名', with: 'test_shop'
          fill_in '郵便番号', with: '1234567'
          select '東京都', from: '都道府県'
          fill_in '市町村', with: ''
          fill_in '番地', with: 'テスト町'
          fill_in 'その他建物など', with: 'testes'
          fill_in '電話番号', with: '0120117117'
          fill_in '営業時間', with: '休：月・火'
          check '予約は可能でしょうか？'
          check '駐車場はありますか？'
          check 'カード可'
          check '景色がよい'
          click_button '登録'
          expect(page).to have_content '店舗を作成できませんでした'
          expect(page).to have_content '市町村を入力してください'
          expect(current_path).to eq shops_path
        end
      end

      context 'streetが未入力' do
        it '新規登録失敗' do
          fill_in '店舗名', with: 'test_shop'
          fill_in '郵便番号', with: '1234567'
          select '東京都', from: '都道府県'
          fill_in '市町村', with: 'テスト市'
          fill_in '番地', with: ''
          fill_in 'その他建物など', with: 'testes'
          fill_in '電話番号', with: '0120117117'
          fill_in '営業時間', with: '休：月・火'
          check '予約は可能でしょうか？'
          check '駐車場はありますか？'
          check 'カード可'
          check '景色がよい'
          click_button '登録'
          expect(page).to have_content '店舗を作成できませんでした'
          expect(page).to have_content '番地を入力してください'
          expect(current_path).to eq shops_path
        end
      end

      context 'telが未入力' do
        it '新規登録失敗' do
          fill_in '店舗名', with: 'test_shop'
          fill_in '郵便番号', with: '1234567'
          select '東京都', from: '都道府県'
          fill_in '市町村', with: 'テスト市'
          fill_in '番地', with: 'テスト町'
          fill_in 'その他建物など', with: 'testes'
          fill_in '電話番号', with: ''
          fill_in '営業時間', with: '休：月・火'
          check '予約は可能でしょうか？'
          check '駐車場はありますか？'
          check 'カード可'
          check '景色がよい'
          click_button '登録'
          expect(page).to have_content '店舗を作成できませんでした'
          expect(page).to have_content '電話番号を入力してください'
          expect(current_path).to eq shops_path
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
          fill_in '店舗名', with: 'updated_name'
          click_button '登録'
          expect(page).to have_content 'updated_name'
          expect(current_path).to eq shop_path(shop)
        end
      end
    end

    describe 'shopの削除' do
      let!(:shop) { create(:shop, user: user) }

      it 'shopの削除に成功する' do
        visit shops_path
        find("#button-delete-#{shop.id}").click

        # Selenium環境ではdata-turbo-confirmが動かないので以下の通りに書いてます
        expect(page).to have_content '削除に成功しました'
        expect(page).not_to have_content shop.name
      end
    end
  end
end

