<template>
  <button @click="addOne">Add 1</button>
</template>

<script>
export default {
  name: "ChangeCounter",
  methods: {
    addOne() {
      this.$store.commit('increment');
    }
  }
}
</script>

<style scoped>

</style>