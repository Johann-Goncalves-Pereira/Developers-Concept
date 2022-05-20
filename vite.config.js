import { defineConfig } from "vite";
import elm from "vite-plugin-elm";
import pluginRewriteAll from "vite-plugin-rewrite-all";

export default defineConfig({
  plugins: [elm(), pluginRewriteAll()],
});
