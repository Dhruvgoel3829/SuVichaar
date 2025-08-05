import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.outsideClickListener = this.closeIfClickedOutside.bind(this)
    document.addEventListener("click", this.outsideClickListener)
  }

  disconnect() {
    document.removeEventListener("click", this.outsideClickListener)
  }

  toggle(event) {
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
  }

  closeIfClickedOutside(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }
} 