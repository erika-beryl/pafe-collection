class ParfaitsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  def index
    @parfaits = Parfait.order(created_at: :desc).page(params[:page]).per(10)

    parfait_ids = @parfaits.pluck(:id)
    @parfait_counts = Parfait
              .select("parfaits.id, COUNT(reviews.id) AS reviews_count")
              .left_joins(:reviews)
              .where(id: parfait_ids)
              .group("parfaits.id")
              .index_by(&:id)

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
  
    # まずレコードを保存してから画像を添付する
    if @parfait.save
      if params[:parfait][:parfait_image].present?
        @parfait.parfait_image.attach(params[:parfait][:parfait_image])
        @parfait.save # 再度保存することで画像をデータベースに関連付け
      end
      redirect_to @parfait, success: 'パフェが登録されました'
    else
      Rails.logger.debug "Parfait errors: #{@parfait.errors.full_messages}"
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Parfait.model_name.human)
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
