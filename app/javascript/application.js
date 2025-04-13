// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import $ from "jquery";
window.$ = $;
window.jQuery = $;
import * as bootstrap from "bootstrap"
import Swiper from 'swiper';
import 'swiper/swiper-bundle.css';
import { Navigation, Pagination } from 'swiper/modules';
Swiper.use([Navigation, Pagination]);


window.bootstrap = bootstrap;

document.addEventListener('turbo:load', () => {
  const swiper = new Swiper('.swiper', {
    loop: true,
    slidesPerView: 1,  // 1枚ずつ表示
    spaceBetween: 10,  // 画像の間隔
    pagination: {
      el: '.swiper-pagination',
      clickable: true,
    },
    navigation: {
      nextEl: '.swiper-button-next',
      prevEl: '.swiper-button-prev',
    },
    scrollbar: {
      el: '.swiper-scrollbar',
    },
  });
});











