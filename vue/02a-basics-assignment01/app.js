const app = Vue.createApp({
  data() {
    return {
      name: "Louis the Greatest",
      age: 17,
      pic: "https://i.natgeofe.com/n/548467d8-c5f1-4551-9f58-6817a8d2c45e/NationalGeographic_2572187_square.jpg"
    }
  },
  methods: {
    getFavoriteNumber() {
      return Math.random();
    }
  }
});

app.mount("#assignment");