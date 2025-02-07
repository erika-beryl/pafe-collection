class ParfaitsController < ApplicationController
  def index
    @parfaits = Parfait.includes(:shop).order(created_at: :desc)
  end

  def new
  end
  
  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

end
