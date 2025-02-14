class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: %i[index]

  def index
    @reviews = Review.includes(:user, parfait: :shop).order(created_at: :desc)
  end

  def new
    # ネストしていないので明示的にparfait_idを書くこと
    @review = Review.new(parfait_id: params[:parfait_id])
  end

  def create
    @review = current_user.reviews.build(review_params)

    if @review.save
      redirect_to parfait_path(@review.parfait), success: 'レビューが投稿されました'
    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Review.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
  
  def review_params
    params.require(:review).permit(:title, :body).merge(user_id: current_user.id, parfait_id: params[:review][:parfait_id])
  end

  def load_review
    @review = Review.includes(:user, parfait: :shop).find(params[id])
  end

end
