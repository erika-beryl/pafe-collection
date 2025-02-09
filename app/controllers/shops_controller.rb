class ShopsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @shops = Shop.all.order(created_at: :desc)
  end

  def new
    @form = ShopMustForm.new
    
  end

  def create
    @form = ShopMustForm.new(shop_params)

    if @form.valid?
      @form.save
      redirect_to shops_path, success: '店舗登録が完了しました'

    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Shop.model_name.human)
      render :new, status: :unprocessable_entity

    end
   
  end

  def edit
    load_shop

    @form = ShopMustForm.new(shop: @shop)
  end

  def update
    load_shop

    @form = ShopMustForm.new(shop_params, shop: @shop)

    if @form.save
      redirect_to @shop, success: '店舗情報が更新されました'
    else
      flash.now[:danger] = '店舗情報を更新できませんでした'
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    load_shop
    @parfaits = @shop.parfaits.order(created_at: :desc)
  end

  def destroy
    load_shop
    @shop.destroy!
    redirect_to shops_path, success: '削除に成功しました'
  end


  private

  def shop_params
    params.require(:shop).permit(:name, :postal_code, :prefecture_code, :city, :street, :other_address, :tel, :parking, :reservation,
    :business_time, feature_ids:[], payment_ids:[])
  end

  def load_shop
    @shop = Shop.find(params[:id])
  end
  
end
