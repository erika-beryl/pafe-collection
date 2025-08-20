class ShopsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @shops = Shop.order(created_at: :desc).page(params[:page]).per(10)

    shop_ids = @shops.pluck(:id)
    @shop_counts = Shop
                   .select("shops.id, COUNT(DISTINCT parfaits.id) AS parfaits_count, COUNT(reviews.id) AS reviews_count")
                   .left_joins(parfaits: :reviews)
                   .where(id: shop_ids)
                   .group("shops.id")
                   .index_by(&:id)
  end

  def new
    @form = ShopMustForm.new
  end

  def create
    # active_strageはshopとは別のデータベースに保存されるので、明示的に切り離しておく
    @form = ShopMustForm.new(shop_params)
    @form.user = current_user

    if @form.valid?
      @form.save
      redirect_to shop_path(@form.shop), success: '店舗登録が完了しました'
    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Shop.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_shop
    redirect_to root_path, alert: '他のユーザーが登録した店舗情報は編集できません' unless @shop.user == current_user

    @form = ShopMustForm.new(shop: @shop)
  end

  def update
    @shop = current_user.shops.find(params[:id])

    @form = ShopMustForm.new(shop_params, shop: @shop)

    if @form.valid?
      @form.save
      redirect_to @shop, success: '店舗情報が更新されました'
    else
      flash.now[:danger] = '店舗情報を更新できませんでした'
      render :edit, status: :unprocessable_entity
    end
  end

  def show
    load_shop
    @parfaits_count = @shop.parfaits.count
    @shop_parfait_reviews_count = @shop.parfaits.joins(:reviews).count
    @parfaits = @shop.parfaits
                     .left_joins(:reviews)
                     .select('parfaits.*, COUNT(reviews.id) AS reviews_count')
                     .group('parfaits.id')
                     .order(created_at: :desc)
    # 店舗毎のレビューを取得するので以下のようにします
    @reviews = Review.joins(:parfait)
                     .where(parfait: { shop_id: @shop.id })
                     .includes(:user)
                     .order(created_at: :desc)
    @bookmark_counts = Bookmark.where(review_id: @reviews.map(&:id)).group(:review_id).count
  end

  def destroy
    @shop = current_user.shops.find(params[:id])
    @shop.destroy!
    redirect_to shops_path, success: '削除に成功しました'
  end

  private

  def shop_params
    params.require(:shop).permit(:name, :postal_code, :prefecture_code, :city, :street, :other_address, :tel, :parking, :reservation,
                                 :shop_image, :remove_shop_image, :business_time, feature_ids: [], payment_ids: [])
  end

  def load_shop
    @shop = Shop.find(params[:id])
  end

end
