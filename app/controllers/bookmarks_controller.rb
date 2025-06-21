class BookmarksController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  def create
    review = Review.find(params[:review_id])
    current_user.bookmark(review)
    redirect_back fallback_location: root_path, success: t('.success')
  end

  def destroy
    review = Review.find(params[:review_id])
    current_user.unbookmark(review)
    redirect_back fallback_location: root_path, success: t('.success')
  end
end
