class ParfaitsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  def index
    @parfaits = Parfait
              .select("parfaits.*, COUNT(reviews.id) AS reviews_count")
              .left_joins(:reviews)
              .group("parfaits.id")
              .order(created_at: :desc)
  end

  def show
    load_parfait
    @reviews = @parfait.reviews.order(created_at: :desc)
  end

  def new
    @parfait = Parfait.new
  end
  
  def create
    @parfait = Parfait.new(parfait_params)

    if params[:parfait][:parfait_image].present?
      @parfait.parfait_image.attach(params[:parfait][:parfait_image])
    end

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
  
    # まず、普通のテキスト情報だけ更新する
    if @parfait.update(parfait_params)
      
      # もし画像を消したいって指示があったら、ここで削除する
      if params[:parfait][:remove_parfait_image] == '1'
        @parfait.parfait_image.purge if @parfait.parfait_image.attached?
      end
  
      # 新しい画像がアップロードされてたら、ここでつけ直す
      if params[:parfait][:parfait_image].present?
        # いったん古い画像があれば消してから
        @parfait.parfait_image.purge if @parfait.parfait_image.attached?
        # 新しい画像を保存
        @parfait.parfait_image.attach(params[:parfait][:parfait_image])
      end
  
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
    @parfait = Parfait.includes(:shop).find(params[:id])
  end

end
