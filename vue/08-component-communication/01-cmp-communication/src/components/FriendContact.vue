<template>
  <li>
    <h2>{{ name }} {{ isFavorite ? "(Favorite)" : ""}}</h2>
    <button @click="toggleFavorite">Toggle Favorite</button>
    <button @click="toggleDetails">{{ detailsAreVisible ? 'Hide' : 'Show' }} Details</button>
    <ul v-if="detailsAreVisible">
      <li>
        <strong>Phone:</strong>
        {{ phoneNumber }}
      </li>
      <li>
        <strong>Email:</strong>
        {{ email }}
      </li>
    </ul>
    <button @click="$emit('delete', id)">Delete</button>
  </li>
</template>

<script>
export default {
  // props: ["name", "phoneNumber", "email"],
  // props: {
  //   name: String,
  //   phoneNumber: String,
  //   email: String,
  // },
  props: {
    id: {
      type: String,
      required: true
    },
    name: {
      type: String,
      required: true,
    },
    phoneNumber: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: false,
      default: "xxx@haha.com",
      // validator: function(value) {
      //   return value === "xxx@haha.com" || value === "yyy@haha.com"; // show warning in console
      // }
    },
    isFavorite: {
      type: Boolean,
      required: false,
      default: false
    }
  },
  emits: ["toggle-favorite", "delete"],
  // emits: {
  //   "toggle-favorite": function(id) {
  //     if (id) {
  //       return true;
  //     } else {
  //       console.warn("id is missing");
  //       return false;
  //     }
  //   }
  // },
  data() {
    return {
      detailsAreVisible: false,
    };
  },
  methods: {
    toggleDetails() {
      this.detailsAreVisible = !this.detailsAreVisible;
    },
    toggleFavorite() {
      this.$emit("toggle-favorite", this.id);
    }
  }
};
</script>