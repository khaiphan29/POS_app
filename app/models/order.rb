class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  # after_commit :broadcast_order_update
  before_save :calculate_total_price

  enum status: { cart: 0, pending: 1, paid: 2, shipped: 3, completed: 4, canceled: 5 }

  scope :cart_for_user, ->(user) { where(user: user, status: :cart) }

  def calculate_total_price
    self.total_price = order_items.sum { |item| item.quantity * item.price }
  end

  private

  # def broadcast_order_update
  #   ActionCable.server.broadcast(
  #     "order_updates",
  #     {
  #       id: id,
  #       total_price: total_price,
  #       updated_at: updated_at.strftime("%Y-%m-%d %H:%M:%S"),
  #       order_items: order_items.map do |item|
  #         {
  #           product_id: item.product_id,
  #           product_name: item.product.name,
  #           quantity: item.quantity,
  #           price: item.price
  #         }
  #       end
  #     }
  #   )
  # end
end
