import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  displayLists() {
    document.getElementById("lists-container").style = "display: block;"
  }
}
