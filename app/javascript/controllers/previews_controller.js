import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="previews"
export default class extends Controller {
  static targets = ["input", "preview"]

  connect() {
    const preview = this.previewTarget
    const width = this.data.get('width')

    if (preview.querySelector("img")) {
      preview.querySelector("img").style.maxWidth = `${width}px`
    }
  }

  previewImage() {
    const input = this.inputTarget
    const preview = this.previewTarget
    const files = input.files
    const width = this.data.get('width')

    if (files && files[0]) {
      const file = files[0];
      const reader = new FileReader();
      
      reader.onload = (e) => {
        const img = new Image();
        img.onload = () => {
          const canvas = document.createElement('canvas');
          const ctx = canvas.getContext('2d');

          const MAX_WIDTH = 800;
          const MAX_HEIGHT = 800;

          let targetWidth = img.width;
          let targetHeight = img.height;

          // 幅か高さがMAXを超えていたら縮小する（縦横比を維持）
          if (targetWidth > MAX_WIDTH || targetHeight > MAX_HEIGHT) {
            const widthRatio = MAX_WIDTH / targetWidth;
            const heightRatio = MAX_HEIGHT / targetHeight;
            const scale = Math.min(widthRatio, heightRatio);
            targetWidth = targetWidth * scale;
            targetHeight = targetHeight * scale;
          }

          canvas.width = targetWidth;
          canvas.height = targetHeight;
          ctx.drawImage(img, 0, 0, targetWidth, targetHeight);

          // プレビュー用に小さく表示
          preview.innerHTML = `<img src="${canvas.toDataURL('image/jpeg')}" style="max-width: ${width}px;">`;

          // inputにリサイズ後のデータをセットする
          canvas.toBlob((blob) => {
            const resizedFile = new File([blob], file.name, { type: 'image/jpeg' });

            const dataTransfer = new DataTransfer();
            dataTransfer.items.add(resizedFile);
            input.files = dataTransfer.files;
          }, 'image/jpeg', 0.8); // 画質80%
        };
        img.src = e.target.result;
      };
      reader.readAsDataURL(file);
    }
  }
}
