
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
   static targets = ["form"];

   connect() {
      console.log("AdminController connected!");
   }

   disconnect() {
      console.log("AdminController disconnected!");
   }

   getForm(event) {
      const url = event.target.dataset.url;
      console.log(`URL: ${url}`);

      event.preventDefault();
      this.fetchForm(url);
   }

   fetchForm(url) {
      fetch(url, { headers: { 'X-Requested-With': 'XMLHttpRequest' } })
         .then(response => response.text())
         .then(html => {
            this.formTarget.innerHTML = html; // Insert the fetched form into the div
         })
         .catch(error => console.error('Error fetching form:', error));
   }
}
