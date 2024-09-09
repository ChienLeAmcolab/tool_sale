// app/javascript/controllers/file_input_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["table"];

  addParameter(event) {
    event.preventDefault();
    const newRow = document.createElement('tr');
    newRow.innerHTML = `
      <td class="py-2 px-4 border-b">
            <input class="w-full px-2 py-1 border border-gray-300 rounded-md focus:ring focus:ring-blue-200 focus:outline-none" placeholder="Parameter Name" type="text" name="parameters[][name]" id="parameters[][name]">
          </td>
      <td class="py-2 px-4 border-b">
            <input class="w-full px-2 py-1 border border-gray-300 rounded-md focus:ring focus:ring-blue-200 focus:outline-none" placeholder="Parameter Value" type="text" name="parameters[][value]" id="parameters[][value]">
          </td>
    `;
    document.getElementById('parameter-table').appendChild(newRow);
  }
}
