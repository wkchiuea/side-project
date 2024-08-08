const app = Vue.createApp({
  data() {
    return {
      alertMsg: "haha Alert",
      userInput1: "",
      userInput2: "",
    }
  },
  methods: {
    showAlert() {
      alert(this.alertMsg);
    },
    showInput1(event) {
      this.userInput1 = event.target.value;
    },
    showInput2() {
      this.userInput2 = this.userInput1;
    }
  }
});

app.mount("#assignment");