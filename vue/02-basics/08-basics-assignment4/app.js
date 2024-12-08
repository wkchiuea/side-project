const app = Vue.createApp({
  data() {
    return {
      userInput: "",
      isVisible: true,
      styleInput: ""
    };
  },
  computed: {
    paraClasses() {
      return {
        user1: this.userInput === "user1",
        user2: this.userInput === "user2",
        visible: this.isVisible,
        hidden: !this.isVisible
      }
    }
  },
  methods: {
    toggleParagraph() {
      this.isVisible = !this.isVisible;
    }
  },
});

app.mount("#assignment");