class ParfaitsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  def index
    @parfaits = Parfait.includes(:shop).order(created_at: :desc)
  end

  def show
    load_parfait
  end

  def new
    @parfait = Parfait.new
  end
  
  def create
    @parfait = Parfait.build(parfait_params)

    if @parfait.save
      redirect_to @parfait, success: 'パフェが登録されました'
    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Shop.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_parfait

  end

  def update
    load_parfait
    if @parfait.update(parfait_params)
      redirect_to @parfait, success: 'パフェが更新されました', status: :see_other
    else
      flash.now[:danger] = "パフェを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    load_parfait
    @parfait.destroy!
    redirect_to parfaits_path, success: '削除に成功しました'
  end

  private

  def parfait_params
    params.require(:parfait).permit(:name, :body, :price, :is_limited).merge(shop_id: params[:shop_id] || @parfait&.shop_id)
  end

  def load_parfait
    @parfait = Parfait.find(params[:id])
  end

end
