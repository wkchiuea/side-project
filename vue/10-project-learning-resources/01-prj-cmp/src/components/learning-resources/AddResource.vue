<template>
  <base-dialog v-if="inputIsInvalid" title="Invalid Input" @close="confirmError">
    <template #default>
      <p>At least one input is invalid</p>
      <p>Please check</p>
    </template>
    <template #actions>
      <base-button @click="confirmError">Okay</base-button>
    </template>
  </base-dialog>
  <base-card>
    <form @submit.prevent="submitData">
      <div class="form-control">
        <label for="title">Title</label>
        <input type="text" id="title" name="title" ref="titleInput">
      </div>
      <div class="form-control">
        <label for="description">Description</label>
        <textarea id="description" name="description" rows="3" ref="descInput"></textarea>
      </div>
      <div class="form-control">
        <label for="link">Link</label>
        <input type="url" id="link" name="link" ref="linkInput">
      </div>
      <div>
        <base-button type="submit">Add Resource</base-button>
      </div>
    </form>
  </base-card>
</template>

<script>
export default {
  name: "AddResources",
  inject: ['addResource'],
  data() {
    return {
      inputIsInvalid: false,
    }
  },
  methods: {
    submitData() {
      const titleInput = this.$refs.titleInput.value;
      const descInput = this.$refs.descInput.value;
      const linkInput = this.$refs.linkInput.value;

      if (titleInput.trim() === "" || descInput.trim() === "" || linkInput.trim() === "") {
        this.inputIsInvalid = true;
        return;
      }

      this.addResource(titleInput, descInput, linkInput);
    },
    confirmError() {
      this.inputIsInvalid = false;
    }
  },
}
</script>

<style scoped>
label {
  font-weight: bold;
  display: block;
  margin-bottom: 0.5rem;
}

input,
textarea {
  display: block;
  width: 100%;
  font: inherit;
  padding: 0.15rem;
  border: 1px solid #ccc;
}

input:focus,
textarea:focus {
  outline: none;
  border-color: #3a0061;
  background-color: #f7ebff;
}

.form-control {
  margin: 1rem 0;
}
</style>