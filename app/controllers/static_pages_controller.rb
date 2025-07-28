class StaticPagesController < ApplicationController
  def top
    @parfaits = Parfait.includes(:shop).order(created_at: :desc).limit(3)
  end
end
