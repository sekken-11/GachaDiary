<template>
<v-container>
  <v-row>
    <v-col>
      <div class="mb-3 px-3 py-5 border rounded shadow">
        <v-col cols="12">
          <div>
            <h4 class="info-title">このサイトでできること</h4>
            <p class="px-2">
              本サイトは、スマホゲーム・ソーシャルゲームのガチャ石（ゲーム内のガチャシステムで使用できる資源の通称）を現金換算するサービスを提供します。<br>
              スマホゲーム・ソーシャルゲームにおいて「ゲームに何円課金したか」ではなく、擬似的に「ゲーム内で何円稼いだか・消費したか」を視覚化・記録することで、通帳の数字が増えていくのを眺めるような、新しい楽しさを提供することを目指してします。<br>
              下記の５機能のうち、<span class="contents-name">現金換算</span>のみユーザー登録をせずにご利用いただけます。その他４機能については、ユーザー登録・ログイン後に利用可能となります。
            </p>
          </div>
        </v-col>
        <v-row class="pt-4 px-2">
          <v-col cols="12" md="4">
            <div>
              <h5 class="page-title">現金換算</h5>
              <p class="px-2">
                特定のゲームでのガチャ石購入時の価格（購入数と金額）と、現金換算したいガチャ石の個数を入力していただくことで、そのガチャ石が何円分かを計算します。
              </p>
            </div>
          </v-col>
          <v-col cols="12" md="4">
            <div>
              <h5 class="page-title">ガチャ記録</h5>
              <p class="px-2">
                ガチャを引いた回数・日付・ゲームなどの情報を記録することができます。<br>
                各情報からの検索・絞り込みも可能です。
              </p>
            </div>
          </v-col>
          <v-col cols="12" md="4">
            <div>
              <h5 class="page-title">ゲーム記録</h5>
              <p class="px-2">
                <span class="contents-name">現金換算</span>と同様に、入力したガチャ石が現金何円分か計算します。<br>
                この記録は保持し続けることができます。
              </p>
            </div>
          </v-col>
        </v-row>
        <v-row class="pt-4 px-2">
          <v-col cols="12" md="4">
            <div>
              <h5 class="page-title">換算用データ</h5>
                ゲーム名・ガチャ石の購入価格を入力することで、ガチャ回数や所持ガチャ石を現金換算するためのデータを作成できます。<br>
                また、データごとにガチャ記録・ガチャ石の所持記録を合計し、確認することができます
              <p class="px-2">
              </p>
            </div>
          </v-col>
          <v-col cols="12" md="4">
            <div>
              <h5 class="page-title">カレンダー</h5>
              <p class="px-2">
                各日付ごとにガチャを引いた回数、それが何円分かをカレンダー形式で確認することができます。
              </p>
            </div>
          </v-col>
        </v-row>
      </div>
    </v-col>
  </v-row>
</v-container>
</template>

<script>
export default {
  name: 'Information',
}
</script>

<style scoped>
.info-title{
  display: flex;  
  align-items: center;
  text-align: center;
  color: gray;
  margin-bottom: 1.5rem;
  letter-spacing: 0.3em;
}
.info-title::before,
.info-title::after{
  content: '';
  height: 1px;
  background-color: gray;
  flex-grow: 1;
  margin: 0px 15px 0px 15px;
}
.page-title{
  text-align: center;
  color: steelblue;
  letter-spacing: 0.3em;
  margin-bottom: 1rem;
}
.contents-name{
  color: steelblue;
  text-decoration: underline steelblue;
}
</style>