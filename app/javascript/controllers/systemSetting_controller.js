import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  toggle() {
    console.log(3)
    const submitButton = document.getElementById('submit-button');
    if (submitButton) {
      submitButton.click();
    }
  }
}
