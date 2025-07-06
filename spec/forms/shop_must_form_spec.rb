require 'rails_helper'

RSpec.describe ShopMustForm, type: :model do
  describe "フォームオブジェクトでの入力テスト" do
    let(:form_attributes) do
      {
        name: "testshop",
        postal_code: "1111111",
        prefecture_code: 13,
        city: "テスト区",
        street: "テスト1-2-3",
        tel: "0312345678",
        reservation: true,
        parking: false
      }
    end
    it '設定したすべてのバリデーションが機能しているか' do
      form = ShopMustForm.new(form_attributes)
      expect(form).to be_valid
      expect(form.errors).to be_empty
    end
    it 'nameがない場合invalid' do
      form = ShopMustForm.new(form_attributes.merge(name: nil))
      expect(form).to be_invalid
      expect(form.errors[:name]).to include "を入力してください"
    end

    it 'postal_codeがない場合invalid' do
      form = ShopMustForm.new(form_attributes.merge(postal_code: nil))
      expect(form).to be_invalid
      expect(form.errors[:postal_code]).to include "を入力してください"
    end

    it 'postal_codeは7桁の半角数字で無い場合invalid' do
      form = ShopMustForm.new(form_attributes.merge(postal_code: '12345678'))
      expect(form).to be_invalid
      expect(form.errors[:postal_code]).to include "は7桁の半角数字で入力してください"
    end

    it 'postal_codeに全角数字を含むとinvalid' do
      form = ShopMustForm.new(form_attributes.merge(postal_code: '１２３４５６７'))
      expect(form).to be_invalid
      expect(form.errors[:postal_code]).to include "は7桁の半角数字で入力してください"
    end

    it 'prefecture_codeがない場合invalid' do
      form = ShopMustForm.new(form_attributes.merge(prefecture_code: nil))
      expect(form).to be_invalid
      expect(form.errors[:prefecture_code]).to include "を入力してください"
    end

    it 'cityがない場合invalid' do
      form = ShopMustForm.new(form_attributes.merge(city: nil))
      expect(form).to be_invalid
      expect(form.errors[:city]).to include "を入力してください"
    end

    it 'streetがない場合invalid' do
      form = ShopMustForm.new(form_attributes.merge(street: nil))
      expect(form).to be_invalid
      expect(form.errors[:street]).to include "を入力してください"
    end

    it 'telがない場合invalid' do
      form = ShopMustForm.new(form_attributes.merge(tel: nil))
      expect(form).to be_invalid
      expect(form.errors[:tel]).to include "を入力してください"
    end

    it 'nameが同じ場合invalid' do
      existing_shop = Shop.create!(form_attributes)
      form_same = ShopMustForm.new(form_attributes, shop: Shop.new)
      expect(form_same.valid?).to eq false
      expect(form_same.errors[:name]).to include "はすでに使われています"
    end
  end
end
