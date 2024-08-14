<template>
  <section>
    <active-user :username="username" :age="age"></active-user>
    <user-data @set-user="setUser"></user-data>
  </section>
</template>

<script>
export default {
  name: "App",
  data() {
    return {
      username: "",
      age: ""
    };
  },
  methods: {
    setUser(inputUserData) {
      this.username = inputUserData.username;
      this.age = inputUserData.age;
    }
  }
};
</script>

<style>
.column {
  float: left;
  width: 50%;
}
</style>