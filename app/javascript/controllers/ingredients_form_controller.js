import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["fields", "template"];

  add(event) {
    event.preventDefault();

    let content = this.templateTarget.innerHTML;

    const uniqueId = new Date().getTime();
    content = content.replace(/NEW_RECORD/g, uniqueId);

    this.fieldsTarget.insertAdjacentHTML("beforeend", content);
  }

  remove(event) {
    event.preventDefault();

    const wrapper = event.target.closest(".ingredient-field");
    const destroyInput = wrapper.querySelector("input[name*='_destroy']");

    if (destroyInput) {
      destroyInput.value = "1";
      wrapper.style.display = "none";
    } else {
      wrapper.remove();
    }
  }
}
