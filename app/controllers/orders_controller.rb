class OrdersController < ApplicationController
  before_action :ensure_authenticated
  before_action :set_order, only: [:show, :destroy]
  before_action :set_cart, only: [:cart, :checkout]

  def index
    @hero_title = "Order"
    @orders = current_user.orders.where(checked_out: true).order(created_at: :desc)
  end

  def show
    unless @order.user == current_user
      redirect_to root_path, alert: "You're not authorized to view this order."
    end
  end

  def create
    product = Product.find(params[:product_id])
    # Assuming there's a current_cart method that retrieves the current order or creates one
    @order = current_cart
    order_item = @order.order_items.find_or_initialize_by(product_id: product.id)
    order_item.quantity = (order_item.quantity || 0) + 1
    order_item.price = product.price

    if order_item.save
      redirect_to products_path, notice: "#{product.name} added to cart successfully."
    else
      redirect_to products_path, alert: 'Failed to add product to cart.'
    end
  end

  def cart
    @hero_title = "Cart"
    # Assuming current_user.orders.find_by(checked_out: false) retrieves the current cart
    @cart = current_user.orders.find_by(checked_out: false)
    @cart_items = @cart.order_items.includes(:product)

    @order_groups = @cart_items.group_by { |item| item.product_id }.map do |product_id, items|
      OpenStruct.new(
        product: items.first.product,
        total_quantity: items.sum(&:quantity),
        total_price: items.sum { |item| item.quantity * item.product.price },
        order_item_id: items.first.id # Assuming only one item per product type
      )
    end
  end

  def update_cart
    params[:cart_items].each do |product_id, details|
      order_item = current_cart.order_items.find_by(product_id: product_id)
      order_item.update(quantity: details[:quantity]) if order_item
    end
    redirect_to cart_path, notice: 'Cart updated successfully.'
  end

  def remove_item_from_cart
    order_item = current_cart.order_items.find_by(id: params[:item_id])
    if order_item
      order_item.destroy
      redirect_to cart_path, notice: 'Item removed from cart successfully.'
    else
      redirect_to cart_path, alert: 'Item could not be found.'
    end
  end

  def checkout
    @cart = current_cart

    # Check if the cart has any items
    if @cart.order_items.empty?
      redirect_to cart_path, alert: 'Your cart is empty. Add some products before checkout.'
      return
    end
    ActiveRecord::Base.transaction do
      @cart.update!(checked_out: true, checked_out_at: Time.current)
      # Additional checkout logic like inventory update, payment processing can be added here
    end
    redirect_to @cart, notice: 'Checkout successful.'
  rescue ActiveRecord::RecordInvalid => e
    redirect_to cart_path, alert: "Checkout failed: #{e.message}."
  end

  def destroy
    if @order.user == current_user && @order.destroy
      redirect_to orders_path, notice: 'Order was successfully deleted.'
    else
      redirect_to orders_path, alert: 'Failed to delete the order.'
    end
  end

  private

  def ensure_authenticated
    redirect_to new_user_session_path unless current_user
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def set_cart
    @cart = current_cart
  end

  def current_cart
    # Find an unchecked-out cart for the current_user or create a new one
    current_user.orders.find_or_create_by(checked_out: false)
  end

  def order_params
    params.require(:order).permit(:product_id, :quantity)
  end

 def destroy_order(order)
  begin
    order.destroy
    true
  rescue => e
    Rails.logger.error "Failed to destroy order #{order.id}: #{e.message}"
    false
  end
end
end
