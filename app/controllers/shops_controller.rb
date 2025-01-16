class ShopsController < ApplicationController
  before_action :user_signed_in?, only: %i[new create]

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
      redirect_to shops_path, flash: {notice: '登録が完了しました'}

    else
      flash[:alert] = "登録に失敗しました: #{@form.errors.full_messages.join(", ")}"
      render :new, status: :unprocessable_entity

    end
   
  end

  def edit
    load_shop

    @form = ShopMustForm.new(shop: @shop)
  end

  def update
    load_shop

    @form = ShopMustForm.new(shop_must_form_params, shop: @shop)

    if @form.save
      redirect_to @shop, notice: '店舗情報が更新されました'
    else
      render :edit
    end
  end

  def show
    @shop = Shop.find(params[:id])
  end


  private

  def shop_params
    params.require(:shop).permit(:name, :postal_code, :prefecture_code, :city, :street, :other_address, :tel, :parking, :reservation)
  end

  def load_shop
    @shop = Shop.find(params[:id])
  end
  
end
