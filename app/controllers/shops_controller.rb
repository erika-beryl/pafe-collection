class ShopsController < ApplicationController
  def index
    @shops = Shop.all
  end

  def new
    @form = Form::ShopMustForm.new
  end

  def create
  end

  private
  
end
