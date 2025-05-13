class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_or_staff!

  def index
    @categories = Category.where.not(name: DUMP_CATEGORY)
    if params[:category].present?
      @products = Product.where(category_id: params[:category])
    else
      @products = Product.where(category_id: @categories.pluck(:id))
    end
    @order = Order.cart_for_user(current_user).first_or_initialize
    @order.save unless @order.persisted?
    @order_count = Order.where(status: :pending).count
  end

  private

  def admin_or_staff!
    unless current_user.admin? || current_user.staff?
      flash[:error] = "Bạn không có quyền truy cập vào trang này"
      sign_out(current_user)
      redirect_to root_path
    end
  end
end
