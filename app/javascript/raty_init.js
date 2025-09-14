import Raty from "./raty";

document.addEventListener("turbo:load", () => {
  console.log("DOMContentLoaded イベント発火");

  // アセットパスを取得する関数
  const getAssetPath = (filename) => {
    const meta = document.querySelector(`meta[name="asset-${filename}"]`);
    return meta ? meta.content : `/assets/${filename}`;
  };

  // フォームの星評価の初期化
  const ratingForm = document.getElementById("review-rating");
  if (ratingForm && !ratingForm.dataset.ratyInitialized) {
    new Raty(ratingForm, {
      starOn: getAssetPath("star-on.png"),
      starOff: getAssetPath("star-off.png"),
      starHalf: getAssetPath("star-half.png"),
      scoreName: "review[rate]"
    });
    ratingForm.dataset.ratyInitialized = "true";
  }

  // 各レビューの星評価の初期化
  document.querySelectorAll("[id^='review-'][id$='-rating']").forEach(el => {
    if (!el.dataset.ratyInitialized) {
      new Raty(el, {
        starOn: getAssetPath("star-on.png"),
        starOff: getAssetPath("star-off.png"),
        starHalf: getAssetPath("star-half.png"),
        readOnly: true,
        score: el.dataset.score || 0
      });
      el.dataset.ratyInitialized = "true";
    }
  });
});
