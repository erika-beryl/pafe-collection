import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="multiple_previews"
export default class extends Controller {
  static targets = ["input", "preview"]

  connect() {
    const preview = this.previewTarget
    const width = parseInt(this.data.get('width')) || 400  // デフォルト値 400

    console.log("Controller connected. Width:", width)

    // すでに画像があれば、すべての画像の幅を設定
    const images = preview.querySelectorAll("img")
    images.forEach(img => {
      img.style.maxWidth = `${width}px`
    })
  }

  previewImage() {
    console.log("previewImage called!")

    const input = this.inputTarget
    const preview = this.previewTarget
    const files = input.files
    const width = parseInt(this.data.get('width')) || 400

    console.log("Selected files:", files)

    // previewエリアをリセット
    preview.innerHTML = ""

    // 複数ファイルが選択されていれば、それぞれに対してプレビューを生成
    if (files && files.length) {
      Array.from(files).forEach(file => {
        const reader = new FileReader()
        reader.onload = (e) => {
          console.log("File loaded:", e.target.result)  // 確認用

          const img = document.createElement("img")
          img.src = e.target.result
          img.style.maxWidth = `${width}px`
          preview.appendChild(img)
        }
        reader.readAsDataURL(file)
      })
    }
  }
}


