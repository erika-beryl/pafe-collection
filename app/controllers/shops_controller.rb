class ShopsController < ApplicationController
  before_action :user_signed_in?, only: %i[new create]

  def index
    @shops = Shop.all
  end

  def new
    @form = ShopMustForm.new
  end

  def create
    @form = ShopMustForm.new(shop_must_form_params)

    if @form.save
      redirect_to shops_path, flash: {notice: '登録が完了しました'}
    else
      flash[:alert] = "登録に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  private

  def shop_must_form_params
    params.require(:shop_must_form).permit(:name, :postal_code, :prefecture, :city, :street, :other_address, :tel, :is_open, :weekly, :open_time, :close_time)
  end
  
end
