const app = Vue.createApp({
  data() {
    return {
      counter: 0,
      name: "",
      confirmedName: "",
    };
  },
  methods: {
    submitForm() {
      alert("haha");
    },
    setName(event, lastName) {
      this.name = event.target.value + " " + lastName;
    },
    setConfirmedName(event) {
      this.confirmedName = event.target.value;
    },
    add() {
      this.counter++;
    },
    reduce() {
      this.counter--;
    }
  }
});

app.mount('#events');
