import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "button"]

  connect() {
    this.listener = this.formTarget.addEventListener('change', () => { this.recount() });
    this.recount();
  }

  disconnect() {
    this.formTarget.removeEventListener('change', this.listener);
  }

  recount() {
    let selected = this.formTarget.querySelectorAll('input[type=checkbox]:checked').length;
    this.updateButton(selected);
  }

  updateButton(selected) {
    if (selected < 1) {
      this.buttonTarget.disabled = true;
      this.buttonTarget.value = "(please select an item to order)"
    } else {
      this.buttonTarget.disabled = false;
      this.buttonTarget.value = `Order ${selected} items`;
    }
  }
}
