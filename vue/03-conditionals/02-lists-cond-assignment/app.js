const app = Vue.createApp({
  data() {
    return {
      taskInput: "",
      tasks: [],
      isShown: true
    };
  },
  methods: {
    addTask() {
      this.tasks.push(this.taskInput);
      this.taskInput = "";
    },
    toggleList() {
      this.isShown = !this.isShown;
    }
  }
})

app.mount("#assignment");