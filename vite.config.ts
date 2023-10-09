import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'

import Vue from '@vitejs/plugin-vue'
import Vuetify from 'vite-plugin-vuetify';

export default defineConfig({
  plugins: [
    RubyPlugin(),
    Vue(),
    Vuetify(),
  ],
})
