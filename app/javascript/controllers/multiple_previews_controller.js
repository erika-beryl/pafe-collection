import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="multiple_previews"
export default class extends Controller {
  static targets = ["input", "preview"]

  previewImage() {
    console.log("previewImage called!")

    const input = this.inputTarget
    const preview = this.previewTarget
    console.log("Selected files:", input.files)

    preview.innerHTML = ""

    if (input.files.length === 0) return;

    Array.from(input.files).forEach((file) => {
      const reader = new FileReader();

      reader.onload = (e) => {
        const img = document.createElement("img");
        img.src = e.target.result;
        img.style.maxWidth = "200px";
        img.style.marginRight = "5px";
        preview.appendChild(img);
      };

      reader.readAsDataURL(file);
    });

    this.previewTarget.parentElement.style.display = "";
  }
}