class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_or_staff!

  def index
    condition = {}
    condition[:user] = current_user unless current_user.admin?
    condition[:status] = params[:status] if params[:status].present?

    @statuses = [
      { name: "Tất cả", value: nil },
      { name: "Đang chờ xử lý", value: Order.statuses[:pending] },
      { name: "Hoàn tất", value: Order.statuses[:completed] },
      { name: "Đã hủy", value: Order.statuses[:canceled] }
    ]
    @orders = Order.where(condition).where.not(status: :cart).order(updated_at: :asc)
  end

  def show
    @order = Order.find(params[:id])
    respond_to do |format|
      format.html { render partial: "orders/form", locals: { order: @order } }
      format.json { render json: @order }
      format.js
    end
  end

  def new
  end

  def edit
    @order = Order.cart_for_user(current_user).first_or_initialize
    @order.save unless @order.persisted?
    render partial "form", locals: { order: @order }
  end

  def update
    @order = Order.find(params[:id])
    not_cenceled!(@order)

    status = Order.statuses.key(params[:status].to_i)
    if @order.update(status: status)
      flash[:success] = "Cập nhật đơn hàng thành công"
    else
      flash[:error] = "Lỗi khi cập nhật đơn hàng"
    end

    respond_to do |format|
      format.js
    end
  end

  def checkout
    order = Order.find(params[:id])
    if order.cart? and order.update(status: :pending) and order.order_items.count > 0
      flash.now[:success] = "Tạo đơn hàng thành công"
      # Broadcast the form to all connected class ClassName
      cart = Order.cart_for_user(current_user).first_or_initialize
      cart.save unless cart.persisted?

      ActionCable.server.broadcast "cart_#{current_user.id}", {
        form_html: render_to_string(partial: "orders/form", locals: { order: cart, cart: true }),
      }
    else
      flash.now[:error] = order.errors.full_messages.to_sentence
    end
    # redirect_to root_path
  end

  def destroy
    order = Order.find(params[:id])
    order.update(status: :canceled)
    flash[:success] = "Đơn hàng đã được hủy"
    redirect_to orders_path
  end

  private
  def order_params
    params.require(:order).permit(:total_price, :status)
  end

  def not_cenceled!(order)
    if order.status == :canceled
      head :conflict
    end
  end

  def admin_or_staff!
    unless current_user.admin? || current_user.staff?
      flash[:error] = "Bạn không có quyền truy cập vào trang này"
      redirect_to root_path
    end
  end
end
