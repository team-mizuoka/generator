<template>
  <div>
    <section class="hero is-primary">
      <div class="hero-body">
        <h1 class="title">Mizuoka Generator</h1>
        <p class="subtitle">水岡が喋ります</p>
      </div>
    </section>

    <div class="container">
      <p class="mt-3 has-text-centered">
        水岡に喋らせたい言葉を入れてください(最大50文字)
      </p>
      <input
        v-model="text"
        class="input mt-3"
        type="text"
        placeholder="水岡に喋らせたい言葉を入れる"
        maxlength="50"
      />
      <div class="buttons is-centered mt-3">
        <button
          @click="generate"
          :class="{ 'is-loading': isLoading }"
          class="button is-primary"
        >
          生成
        </button>
      </div>
    </div>

    <div v-if="isSuccess" class="container mt-5">
      <h2 class="title is-2 has-text-centered">生成された画像</h2>
      <div class="columns is-flex is-centered">
        <figure class="image is-128x128">
          <img :src="location" />
        </figure>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from "vue";
import "./styles.scss";
import "./lib/api";
import { Configuration, GenerateApi } from "./lib/api";

export default Vue.extend({
  data: function () {
    return {
      text: "",
      location: "",
      isSuccess: false,
      isLoading: false,
    };
  },
  methods: {
    generate() {
      this.isLoading = true;
      this.isSuccess = false;
      const api = new GenerateApi(
        new Configuration(),
        "https://mizuoka-generator.an.r.appspot.com",
        fetch
      );
      api.generatePost(this.text).then((res) => {
        this.isLoading = false;
        this.location = res.location;
        this.isSuccess = true;
      })
      .catch((res) => {
        this.isLoading = false;
      });
    },
  },
});
</script>
