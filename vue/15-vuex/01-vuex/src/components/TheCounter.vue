<template>
  <h3>{{ finalCounter }}</h3>
</template>

<script>
import {mapGetters} from "vuex";

export default {
  name: "TheCounter",
  computed: {
    counter() {
      return this.$store.getters['numbers/normalizedCounter'];
    },
    // ...mapGetters('numbers', ['finalCounter'])
  },
}
</script>

<style scoped>

</style>