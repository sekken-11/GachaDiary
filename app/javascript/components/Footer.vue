<template> 
  <footer class="background mt-auto border-top">
    <nav class="firstbar navbar py-4 mx-5">
      <div class="secondbar-block flex-fill py-3" @click="toPages(Information)">
        <router-link :to="{ name: Information }" class="secondbar-link">このサイトについて</router-link>
      </div>
      <div class="secondbar-block flex-fill py-3 border-end border-start" @click="toPages(Terms)">
        <router-link :to="{ name: Terms }" class="secondbar-link">利用規約</router-link>
      </div>
      <div class="secondbar-block flex-fill py-3" @click="toPages(Policy)">
        <router-link :to="{ name: Policy }" class="secondbar-link">プライバシーポリシー</router-link>
      </div>
    </nav>
    <nav class="navbar">
      <small class="flex-fill text-muted pb-3">&copy; 2023 gachadiary38971 All Rights Reserved.</small>
    </nav>
  </footer>
</template>

<script>
export default {
  name: "Footer",
  data() {
    return {
      Information: "Information",
      Policy: "Policy",
      Terms: "Terms",
    }
  },
  methods: {
    toMypage() {
      this.$router.push({ name: 'MyPage' })
    },
    toPages(link) {
      this.$router.push({ name: link })
    },
  }
}
</script>

<style scoped>
.background{
  background-color: white;
  text-align: center;
}
.firstbar{
  background-color: white;
  color: black;
}
.secondbar{
  background-color: snow;
}
.secondbar-block{
  text-align: center;
}
.secondbar-block:hover{
  text-align: center;
  background: linear-gradient(snow, lavender);
}
.secondbar-link{
  color: gray;
  text-decoration: none;
}
@media (min-width:768px) {
  footer {
    font-size: 130%;
  }
}
</style>