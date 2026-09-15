import { Controller } from "@hotwired/stimulus"

const DESKTOP_VISIBLE = 4

export default class extends Controller {
  static targets = ["slide", "counter"]

  connect() {
    this.front = 0
    this.render()
  }

  next() {
    this.front = (this.front - 1 + this.slideTargets.length) % this.slideTargets.length
    this.render()
  }

  previous() {
    this.front = (this.front + 1) % this.slideTargets.length
    this.render()
  }

  render() {
    const total = this.slideTargets.length
    const visible = Math.min(DESKTOP_VISIBLE, total)

    this.slideTargets.forEach((slide, index) => {
      const position = (index - this.front + total) % total
      if (position < visible) {
        slide.dataset.position = position
        slide.style.order = position
      } else {
        delete slide.dataset.position
        slide.style.order = ""
      }
    })

    if (this.hasCounterTarget) this.counterTarget.textContent = `${this.front + 1}/${total}`
  }
}
