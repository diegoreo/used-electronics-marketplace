import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  scroll() {
    const url = new URL(window.location.href)
    if (!url.searchParams.has("scroll_to_chat")) return

    this.element.scrollIntoView()

    url.searchParams.delete("scroll_to_chat")
    history.replaceState(history.state, "", url)
  }
}
