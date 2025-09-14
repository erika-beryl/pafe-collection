import Raty from "./raty";

document.addEventListener("turbo:load", () => {
  console.log("DOMContentLoaded イベント発火");

  // フォームの星評価の初期化
  const ratingForm = document.getElementById("review-rating");
  if (ratingForm && !ratingForm.dataset.ratyInitialized) {
    new Raty(ratingForm, {
      starOn: "/assets/star-on.png",
      starOff: "/assets/star-off.png",
      starHalf: "/assets/star-half.png",
      scoreName: "review[rate]"
    });
    ratingForm.dataset.ratyInitialized = "true";
  }

  // 各レビューの星評価の初期化
  document.querySelectorAll("[id^='review-'][id$='-rating']").forEach(el => {
    if (!el.dataset.ratyInitialized) {
      new Raty(el, {
        readOnly: true,
        score: el.dataset.score || 0
      });
      el.dataset.ratyInitialized = "true";
    }
  });
});
