import { Controller } from "@hotwired/stimulus"
import { OrderChannel } from "../channels/order_channel"

export default class extends Controller {
   static targets = ["form", "items", "totalPrice"]
   static orderChannel = null

   connect() {
      if (!this.orderChannel) {
         this.orderChannel = new OrderChannel(this);
      }
      console.log("OrderController connected");
   }

   disconnect() {
      this.orderChannel.unsubscribe();
      console.log("OrderController disconnected");
   }

   changeItemQuantity(event) {
      event.preventDefault();
      const productId = event.currentTarget.dataset.id;
      const quantity = event.currentTarget.dataset.quantity ?? 1;

      if (!productId) {
         console.error("Product ID is missing");
         return;
      }
      this.orderChannel.changeItemQuantity(productId, quantity);
   }

   setItemQuantity(event) {
      if (event.key === "Enter") {
         event.preventDefault();
         const quantity = event.currentTarget.value;
         const productId = event.currentTarget.dataset.id;
         console.log("Set item quantity:", quantity);

         this.orderChannel.setItemQuantity(productId, quantity);
         event.currentTarget.blur(); // Remove focus from the input field
      }
      else if (event.type === "click") {
         const quantity = event.currentTarget.dataset.quantity;
         const productId = event.currentTarget.dataset.id;
         console.log("Set item quantity:", quantity);

         this.orderChannel.setItemQuantity(productId, quantity);
      }
   }

   addItem(data) {
      this.itemsTarget.insertAdjacentHTML("beforeend", data.html); // Adds the new HTML as the last child
      console.log("Order updated with new HTML");
   }

   deleteItem(data) {
      const item = this.formTarget.querySelector(`[item-id="${data.product_id}"]`);
      item.remove();
      console.log("Item removed from order:", data.product_id);
   }

   updateItem(data) {
      const item = this.formTarget.querySelector(`[item-id="${data.product_id}"]`);
      const quantityInput = item.querySelector("input[type='number']");
      quantityInput.value = data.quantity;
      console.log("Item updated in order:", data.product_id);
   }

   updateForm(form_html) {
      this.formTarget.outerHTML = form_html;
   }

   updateTotalPrice(price) {
      const formattedPrice = Number(price).toLocaleString('vi-VN', {
         maximumFractionDigits: 0,
         style: 'currency',
         currency: 'VND',
      });
      console.log("Total price updated:", formattedPrice);
      this.totalPriceTarget.innerText = formattedPrice;
   }

}
