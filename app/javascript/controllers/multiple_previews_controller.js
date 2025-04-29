import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="multiple-previews"
export default class extends Controller {
  static targets = ["input", "preview"]

  previewImage() {
    const input = this.inputTarget
    const preview = this.previewTarget
    preview.innerHTML = ""  // プレビューエリアを空っぽにする

    if (input.files.length === 0) return;  // ファイルがなかったら何もしない

    // えらばれたファイルをひとつずつ見る
    for (let i = 0; i < input.files.length; i++) {
      const file = input.files[i];

      const reader = new FileReader();
      reader.onload = (e) => {
        const img = document.createElement("img");
        img.src = e.target.result;  // 読み込んだ画像データをimgにセット
        img.style.maxWidth = "200px";  // プレビュー画像の大きさを小さめに
        img.style.marginRight = "5px";  // 画像同士の間にすこしスペースを空ける
        preview.appendChild(img);  // プレビューエリアに画像を追加
      };
      
      reader.readAsDataURL(file);  // ファイルを読み込む
    }

    // プレビューエリアを見えるようにする
    this.previewTarget.parentElement.style.display = "";
  }
}
