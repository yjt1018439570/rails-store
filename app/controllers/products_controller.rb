class ProductsController < ApplicationController
  @hero_title = "Shop"
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :image)
  end
end
