class OrderChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    Rails.logger.info("Subscribed to OrderChannel for user #{current_user.id}")
    stream_from "cart_#{current_user.id}"
  end

  def change_item_quantity_by(data)
    modify_item_quantity(data) do |current_quantity, quantity|
      current_quantity + quantity
    end
  end

  def set_item_quantity_to(data)
    modify_item_quantity(data) do |current_quantity, quantity|
      quantity
    end
  end


  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  private
  def modify_item_quantity(data)
    # Find cart and update the order item quantity
    cart = Order.cart_for_user(current_user).first_or_initialize
    product_id = data["product_id"]
    quantity = data["quantity"].to_i
    item = cart.order_items.where(product_id: product_id).first_or_initialize

    quantity = yield(item.quantity, quantity)
    item.quantity = quantity
    item.price = item.product.price

    if item.persisted?
      if item.save and cart.save
        # Broadcast the updated cart to client
        Rails.logger.info("Updating existing order item for product_id: #{product_id}")
        ActionCable.server.broadcast(
          "cart_#{current_user.id}",
          {
            product_id: product_id,
            quantity: quantity,
            total_price: cart.total_price
          }
        )
        item.destroy if item.quantity <= 0
      end
    else
      # Create a new item
      if item.save and cart.save
        # Broadcast the updated cart to client
        Rails.logger.info("Creating new order item for product_id: #{product_id}")
        ActionCable.server.broadcast(
          "cart_#{current_user.id}",
          {
            html: ApplicationController.render(
              partial: "orders/item",
              locals: { item: item, cart: true }
            ),
            total_price: cart.total_price
          }
        )
      end
    end
  end
end
