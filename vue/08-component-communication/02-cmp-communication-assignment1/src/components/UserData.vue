<template>
  <form class="column" @submit.prevent="submitData">
    <div>
      <label>Username : </label>
      <input type="text" v-model="inputUsername" />
    </div>
    <div>
      <label>Age : </label>
      <input type="text" v-model="inputAge" />
    </div>
    <button>Submit</button>
  </form>
</template>

<script>
export default {
  name: "UserData",
  emits: ["set-user"],
  data() {
    return {
      inputUsername: "",
      inputAge: ""
    }
  },
  methods: {
    submitData() {
      const userData = {
        username: this.inputUsername,
        age: this.inputAge,
      }
      this.$emit("set-user", userData);
    }
  }
};
</script>

<style scoped>

</style>