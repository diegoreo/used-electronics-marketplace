import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["slide", "thumbnail", "lightbox", "lightboxImage"]

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

    if (!this.lightboxTarget.classList.contains("hidden")) {
      this.lightboxImageTarget.src = this.slideTargets[index].src
    }
  }

  open() {
    this.lightboxImageTarget.src = this.slideTargets[this.currentIndex].src
    this.lightboxTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
  }

  close() {
    this.lightboxTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
  }

  closeOnBackdrop(event) {
    if (event.target === this.lightboxTarget) this.close()
  }

  closeOnEscape(event) {
    if (event.key === "Escape" && !this.lightboxTarget.classList.contains("hidden")) this.close()
  }
}
