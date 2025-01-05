import { Controller } from "@hotwired/stimulus";

export default class FlashController extends Controller {
  static values = {
    dismissAfter: { type: Number, default: 5000 }  // Time in milliseconds
  }

  connect() {
    // Add close button
    this.addCloseButton()
    
    // Start auto-dismiss timer
    if (this.dismissAfterValue > 0) {
      this.autoDismissTimeout = setTimeout(() => {
        this.dismiss()
      }, this.dismissAfterValue)
    }
  }

  disconnect() {
    // Clear timeout if element is removed
    if (this.autoDismissTimeout) {
      clearTimeout(this.autoDismissTimeout)
    }
  }

  addCloseButton() {
    const closeButton = document.createElement('button')
    closeButton.innerHTML = '×'
    closeButton.className = 'btn btn-dark'
    closeButton.addEventListener('click', () => this.dismiss())
    this.element.appendChild(closeButton)
  }

  dismiss() {
    this.element.style.transition = 'opacity 0.5s ease'
    this.element.style.opacity = '0'
    
    setTimeout(() => {
      this.element.remove()
    }, 500)
  }
}



