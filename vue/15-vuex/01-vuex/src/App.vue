<template>
  <base-container title="Vuex">
    <the-counter></the-counter>
    <button @click="increment">Add 10</button>
    <change-counter></change-counter>
  </base-container>
</template>

<script>
import BaseContainer from './components/BaseContainer.vue';
import TheCounter from "./components/TheCounter.vue";
import ChangeCounter from "./components/ChangeCounter.vue";
import {mapActions} from "vuex";

export default {
  components: {
    BaseContainer,
    TheCounter,
    ChangeCounter
  },
  methods: {
    addOne() {
      // this.$store.dispatch('increment');
      // this.$store.commit('increase', {value: 10});
      // this.$store.commit({
      //   type: 'increase',
      //   value: 10,
      // });
    },
    ...mapActions(['increment']),
    // ...mapActions({
    //   inc: 'increment'
    // })
  }
};
</script>

<style>
* {
  box-sizing: border-box;
}

html {
  font-family: sans-serif;
}

body {
  margin: 0;
}
</style>