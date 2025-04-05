// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import $ from "jquery";
import "slick-carousel";  // slickをインポート
import "slick-carousel/slick/slick.css";
import "slick-carousel/slick/slick-theme.css"; 
import * as bootstrap from "bootstrap"

window.$ = window.jQuery = $;
window.bootstrap = bootstrap

document.addEventListener("turbo:load", function () {
  $(".slider").slick({
    arrows: false,
    autoplay: true,
    autoplaySpeed: 4000,
    infinite: true,
    slidesToShow: 1,
    centerMode: true
  });
});
