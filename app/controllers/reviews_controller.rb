class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @reviews = Review.includes(parfait: :shop, :user).order(created_at: :desc)
  end

  private
  
  def review_params
    params.require(:review).permit(:title, :body).merge(user_id: params[:user_id] || @review.user_id, parfait_id: params[:parfait_id] || @review.parfait_id)
  end

end
