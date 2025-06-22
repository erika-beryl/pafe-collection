class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @reviews = Review.includes(:user, parfait: :shop).order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
    # ネストしていないので明示的にparfait_idを書く
    @review = Review.new(parfait_id: params[:parfait_id])
  end

  def create
    @review = current_user.reviews.build(review_params)

    if params[:review][:review_images].present?
      @review.review_images.attach(params[:review][:review_images])
    end

    if @review.save
      redirect_to parfait_path(@review.parfait), success: 'レビューが投稿されました'
    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Review.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show
    load_review

  end

  def edit
    @review = current_user.reviews.find_by(id: params[:id])

    if @review.nil?
      redirect_to root_path, alert: '他のユーザーのレビューは編集できません'
    end
  end

  def update
    @review = current_user.reviews.find(params[:id])

    params[:review][:image_ids].to_a.each do |image_id|
      image = @review.review_images.find { |img| img.blob.id.to_s == image_id }
      image.purge if image.present? && @review.user == current_user
    end

    if params[:review][:review_images].present?
      @review.review_images.attach(params[:review][:review_images])
    end

    if @review.update(review_params)
      redirect_to parfait_path(@review.parfait), success: 'レビューが更新されました', status: :see_other
    else
      flash.now[:danger] = "レビューを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review = current_user.reviews.includes(:user, parfait: :shop).find(params[:id])
    parfait = @review.parfait 
    @review.destroy!
    redirect_to parfait_path(parfait), success: '削除に成功しました'
  end

  def bookmarks
    @bookmark_reviews = current_user.bookmark_reviews.includes(:user).order(created_at: :desc)
  end

  private
  
  def review_params
    params.require(:review).permit(:title, :body).merge(user_id: current_user.id, parfait_id: params[:review][:parfait_id])
  end

  def load_review
    @review = Review.includes(:user, parfait: :shop).find(params[:id])
  end

end
