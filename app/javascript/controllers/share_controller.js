import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String, title: String, copiedLabel: String }
  static targets = ["label"]

  share() {
    if (navigator.share) {
      navigator.share({ title: this.titleValue, url: this.urlValue }).catch(() => {})
    } else {
      this.copyLink()
    }
  }

  copyLink() {
    navigator.clipboard.writeText(this.urlValue).then(() => {
      const original = this.labelTarget.textContent
      this.labelTarget.textContent = this.copiedLabelValue
      setTimeout(() => { this.labelTarget.textContent = original }, 2000)
    })
  }
}
