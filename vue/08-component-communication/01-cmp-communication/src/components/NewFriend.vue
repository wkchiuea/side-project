<template>
  <form @submit.prevent="submitData">
    <div>
      <label>Name</label>
      <input type="text" v-model="inputName" />
    </div>
    <div>
      <label>Phone</label>
      <input type="tel" v-model="inputPhone" />
    </div>
    <div>
      <label>Email</label>
      <input type="email" v-model="inputEmail" />
    </div>
    <div>
      <button>Add Contact</button>
    </div>
  </form>
</template>

<script>
export default {
  name: "NewFriend",
  emits: ["add-friend"],
  data() {
    return {
      inputName: "",
      inputPhone: "",
      inputEmail: ""
    }
  },
  methods: {
    submitData() {
      const friendData = {
        name: this.inputName,
        phone: this.inputPhone,
        email: this.inputEmail
      };
      this.$emit("add-friend", friendData);
    }
  }
}
</script>

<style scoped>

</style>