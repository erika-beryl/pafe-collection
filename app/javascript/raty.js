class Raty {
  constructor(element, options = {}) {
    this.element = element;
    this.opt = { 
      ...this.defaultOptions(), 
      ...options, 
      ...this._parseOptions(element.dataset) 
    };
    this.init();
  }

  defaultOptions() {
    return {
      cancelButton: false,
      cancelClass: 'raty-cancel',
      cancelHint: 'Cancel this rating!',
      cancelOff: 'cancel-off.png',
      cancelOn: 'cancel-on.png',
      number: 5,
      readOnly: false,
      score: undefined,
      scoreName: 'comment[rate]', // フォームで使用するフィールド名
      starHalf: '/assets/star-half.png',
      starOff: '/assets/star-off.png',
      starOn: '/assets/star-on.png',
      target: "#comment_rate",
      targetKeep: true,
    };
  }

  init() {
    this._setPath();
    this._createStars();
    this._createScoreField();

    if (this.opt.readOnly) {
      this._lock();
    } else {
      this._bindEvents();
    }

    this.setScore(this.opt.score);
  }

  setScore(score) {
    score = this._adjustScore(score);
    this._apply(score);
    this._setHiddenField(score);
  }

  getScore() {
    return this.scoreField ? this.scoreField.value : 0;
  }

  _apply(score) {
    this._fillStars(score);
    if (score) {
      this.scoreField.value = score;
    }
  }

  _setHiddenField(score) {
    if (this.opt.target) {
      const hiddenField = document.querySelector(this.opt.target);
      if (hiddenField) {
        hiddenField.value = score;
      }
    }
  }

  _fillStars(score) {
    this.stars.forEach((star, index) => {
      if (index + 1 <= score) {
        star.src = this.opt.starOn;
      } else if (index < score && index + 0.5 <= score) {
        star.src = this.opt.starHalf;
      } else {
        star.src = this.opt.starOff;
      }
    });
  }

  _createStars() {
    this.stars = [];
    for (let i = 1; i <= this.opt.number; i++) {
      const star = document.createElement("img");
      star.src = this.opt.starOff;
      star.dataset.score = i;
      this.element.appendChild(star);
      this.stars.push(star);
    }
  }

  _createScoreField() {
    this.scoreField = document.createElement("input");
    this.scoreField.type = "hidden";
    this.scoreField.name = this.opt.scoreName;
    this.element.appendChild(this.scoreField);
  }

  _bindEvents() {
    this.stars.forEach((star) => {
      star.addEventListener("click", (event) => {
        const score = event.target.dataset.score;
        this.setScore(score);
      });
    });
  }

  _lock() {
    this.stars.forEach(star => star.style.pointerEvents = "none");
  }

  _adjustScore(score) {
    return Math.min(Math.max(parseFloat(score) || 0, 0), this.opt.number);
  }

  _setPath() {
    this.opt.path = this.opt.path || '';
  }

  _parseOptions(dataset) {
    return Object.keys(dataset).reduce((acc, key) => {
      let value = dataset[key] === "true" ? true : dataset[key] === "false" ? false : dataset[key];
      if (!isNaN(value) && Number.isInteger(parseFloat(value))) {
        value = Number(value);
      }
      acc[key] = value;
      return acc;
    }, {});
  }
}

export default Raty;
