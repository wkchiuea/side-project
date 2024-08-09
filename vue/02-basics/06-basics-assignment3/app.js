const app = Vue.createApp({
  data() {
    return {
      numValue: 0,
    };
  },
  computed: {
    result() {
      if (this.numValue < 37) {
        return "Not there yet";
      } else if (this.numValue === 37) {
        return this.numValue;
      } else {
        return "Too much!";
      }
    }
  },
  watch: {
    result() {
      const that = this;
      setTimeout(function() {
        that.numValue = 0;
      }, 5000);
    }
  },
  methods: {
    addValue(val) {
      this.numValue += val;
    }
  }
});

app.mount("#assignment");