import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "thumbnail"]

  connect() {
    this.currentIndex = 0
  }

  show(event) {
    this.goTo(parseInt(event.params.index, 10))
  }

  next() {
    this.goTo((this.currentIndex + 1) % this.slideTargets.length)
  }

  previous() {
    this.goTo((this.currentIndex - 1 + this.slideTargets.length) % this.slideTargets.length)
  }

  goTo(index) {
    this.slideTargets.forEach((slide, i) => slide.classList.toggle("hidden", i !== index))
    this.thumbnailTargets.forEach((thumb, i) => {
      thumb.classList.toggle("border-brand-gold", i === index)
      thumb.classList.toggle("border-transparent", i !== index)
    })
    this.currentIndex = index
  }
}
