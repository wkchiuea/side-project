const app = Vue.createApp({
  data() {
    return {
      courseGoalA: "Haha",
      courseGoalB: "Hehehehe",
      courseGoalC: "<h5>Header Haha</h5>",
      vueLink: "https://vuejs.org/",
    };
  },
  methods: {
    getGoal() {
      if (Math.random() < 0.5) {
        return this.courseGoalA;
      } else {
        return this.courseGoalB;
      }
    }
  }
});

app.mount("#user-goal");