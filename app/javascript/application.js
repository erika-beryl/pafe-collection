// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import $ from "jquery";
window.$ = $;
window.jQuery = $;
import * as bootstrap from "bootstrap"

import Swiper from 'swiper';
import { Navigation, Pagination, Scrollbar } from 'swiper/modules';
Swiper.use([Navigation, Pagination, Scrollbar]);


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

document.addEventListener('DOMContentLoaded', function() {
  const form = document.querySelector('.new_parfait');
  const submitButton = form.querySelector('input[type="submit"], button[type="submit"]');

  form.addEventListener('submit', function(event) {
    // フォーム送信中にボタンを無効化
    submitButton.disabled = true;
  });
});


