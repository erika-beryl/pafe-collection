class BookmarksController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  def create
    @review = Review.find(params[:review_id])
    current_user.bookmark(@review)
  end

  def destroy
    @review = current_user.bookmarks.find(params[:id]).review
    current_user.unbookmark(@review)
  end

end
