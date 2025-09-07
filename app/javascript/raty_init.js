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
  const reviews = JSON.parse(document.getElementById("reviews-data")?.textContent || "[]");
  reviews.forEach(review => {
    const reviewRatingElement = document.getElementById(`review-${review.id}-rating`);
    if (reviewRatingElement && !reviewRatingElement.dataset.ratyInitialized) {
      new Raty(reviewRatingElement, {
        starOn: "/assets/star-on.png",
        starOff: "/assets/star-off.png",
        starHalf: "/assets/star-half.png",
        readOnly: true,
        score: review.rate
      });
      reviewRatingElement.dataset.ratyInitialized = "true";
    }
  });
});
