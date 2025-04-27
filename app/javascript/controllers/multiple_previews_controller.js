import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="multiple-previews"
export default class extends Controller {
  static targets = ["input", "preview"]

  // 画像圧縮を行う
  compressImage(file, maxWidth = 1000, maxHeight = 1000, quality = 0.7) {
    return new Promise((resolve, reject) => {
      const img = new Image();
      const reader = new FileReader();

      reader.onload = (e) => {
        img.src = e.target.result;

        img.onload = () => {
          const canvas = document.createElement("canvas");
          const ctx = canvas.getContext("2d");

          // 新しい画像のサイズを計算
          const width = img.width;
          const height = img.height;

          const ratio = Math.min(maxWidth / width, maxHeight / height);
          const newWidth = width * ratio;
          const newHeight = height * ratio;

          canvas.width = newWidth;
          canvas.height = newHeight;

          // 画像を描画
          ctx.drawImage(img, 0, 0, newWidth, newHeight);

          // 圧縮した画像をBase64として取得
          canvas.toBlob(
            (blob) => {
              const compressedFile = new File([blob], file.name, {
                type: "image/jpeg",
                lastModified: Date.now(),
              });
              resolve(compressedFile);  // 圧縮されたファイルを返す
            },
            "image/jpeg",
            quality
          );
        };
      };

      reader.readAsDataURL(file);
    });
  }

  // 画像が選択された時の処理
  async previewImage() {
    const input = this.inputTarget
    const preview = this.previewTarget
    preview.innerHTML = ""  // プレビューエリアをクリア

    if (input.files.length === 0) return;

    // 複数の画像を処理
    for (let i = 0; i < input.files.length; i++) {
      const file = input.files[i];
      
      // 画像を圧縮
      const compressedFile = await this.compressImage(file);
      
      // 圧縮後の画像をプレビュー表示
      const reader = new FileReader();
      reader.onload = (e) => {
        const img = document.createElement("img");
        img.src = e.target.result;
        img.style.maxWidth = "200px";
        img.style.marginRight = "5px";
        preview.appendChild(img);
      };
      
      reader.readAsDataURL(compressedFile);

      // 圧縮された画像をformに追加 (Hiddenフィールドでアップロード用に送信)
      const dataTransfer = new DataTransfer();
      dataTransfer.items.add(compressedFile);
      input.files = dataTransfer.files;
    }

    this.previewTarget.parentElement.style.display = "";
  }
}
