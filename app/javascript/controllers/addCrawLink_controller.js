import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["table"];

  addCrawLink(event) {
    event.preventDefault();
    const newRow = document.createElement('div');
    newRow.innerHTML = `
    <div class="flex space-x-4 mb-5">
      <input type="text" class="flex-grow px-4 py-2 ms-4 border border-gray-300 rounded-md focus:ring focus:ring-blue-200 focus:outline-none" value="">
    </div>
    `;
    document.getElementById('input_craw').appendChild(newRow);
  }
}
