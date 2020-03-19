<template>
  <div id="app">
    <header class="text-center">Vue App</header>

    <form class="text-center" id="form">
      <input
        type="text"
        placeholder="Full Name"
        id="full-name"
        v-model="fullName"
      />

      <button @click.prevent="onSubmit">Submit</button>
    </form>

    <div id="container" class="text-center">
      <div id="text-full-name">
        <small>Full Name:</small>

        <h2>{{ dataFromNative }}</h2>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'App',

  data() {
    return {
      fullName: '',
      dataFromNative: ''
    }
  },

  mounted() {
    window.webview = this
  },

  methods: {
    onSubmit() {
      if (this.fullName) {
        if (window.webkit) {
          return window.webkit.messageHandlers.sampleFunction
            .postMessage(this.fullName)
        }
      }
    },

    listenerFromNative(payload) {
      this.dataFromNative = payload
    }
  }
}
</script>

<style></style>
