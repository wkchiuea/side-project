<template>
  <section class="column">
    <h2>Username : {{ username }}</h2>
    <h3>Age : {{ age }}</h3>
  </section>
</template>

<script>
export default {
  name: "ActiveUser",
  props: ["username", "age"],
}
</script>

<style scoped>

</style>