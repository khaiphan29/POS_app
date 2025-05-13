import consumer from "channels/consumer"

export class OrderChannel {
   static subscription = null
   constructor(controller) {
      this.controller = controller;
      this.subscribe();
   }

   connected() {
      console.log("connected to OrderChannel");
   }

   disconnected() {
   }

   received(data) {
      // called when there's incoming data on the websocket for this subscription
      console.log("received data:", data);
      if (data.form_html) {
         this.controller.updateForm(data.form_html);
      }

      if (data.html) {
        this.controller.addItem(data);
      }
      else if (data.quantity == 0) {
         this.controller.deleteItem(data);
      }
      else {
         this.controller.updateItem(data);
      }

      this.controller.updateTotalPrice(data.total_price);
   }

   changeItemQuantity(product_id, quantity) {
      console.log("updating order item:", product_id, quantity);
      const orderItem = { product_id: product_id, quantity: quantity };
      OrderChannel.subscription.perform('change_item_quantity_by', orderItem);
   }

   setItemQuantity(product_id, quantity) {
      console.log("set item quantity", product_id, quantity);
      const orderItem = { product_id: product_id, quantity: quantity };
      OrderChannel.subscription.perform('set_item_quantity_to', orderItem);
   }

   subscribe() {
      if (OrderChannel.subscription) {
         console.log("subscription already exists");
         return;
      }
      OrderChannel.subscription = consumer.subscriptions.create("OrderChannel", {
         connected: this.connected.bind(this),
         disconnected: this.disconnected.bind(this),
         received: this.received.bind(this),
      })
   }

   unsubscribe() {
      if (OrderChannel.subscription) {
         OrderChannel.subscription.unsubscribe();
         OrderChannel.subscription = null;
         console.log("OrderChannel unsubscribed");
      }
   }
}
