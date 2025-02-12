class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @reviews = Review.includes(:user, parfait: :shop).order(created_at: :desc)
  end

  private
  
  def review_params
    params.require(:review).permit(:title, :body).merge(user_id: current_user.id, parfait_id: params[:parfait_id] || @review.parfait_id)
  end

  def load_review
    @review = Review.includes(:user, parfait: :shop).find(params[id])
  end

end
