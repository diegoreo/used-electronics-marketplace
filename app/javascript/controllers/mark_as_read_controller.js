import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }

  connect() {
    this.markRead()
  }

  markRead(event) {
    if (event && event.target.getAttribute("target") !== "messages") return

    const token = document.querySelector('meta[name="csrf-token"]')?.content
    fetch(this.urlValue, {
      method: "PATCH",
      headers: token ? { "X-CSRF-Token": token } : {}
    })
  }
}
