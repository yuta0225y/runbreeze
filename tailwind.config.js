module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [require("daisyui")],
  daisyui: {
    themes: [
      {
        mytheme: {
          "primary": "#5C6AC4",         // メインカラーは薄めのブルー系。ボタンやリンクなど、主要アクションに使用
          "secondary": "#A0AEC0",       // 補助カラーはグレー系。非アクティブ要素やサブアクションに使用
          "accent": "#718096",          // アクセントカラーはダークグレー系。強調したいアイコンや装飾に使用
          "neutral": "#E2E8F0",         // ニュートラルカラーとして淡いグレーを背景や境界線に使用
          "base-100": "#FFFFFF",        // 基本背景色は白でシンプルに
          "base-200": "#F7FAFC",        // サブ背景色として薄いグレー
          "base-300": "#EDF2F7",        // カードやコンテンツの区切りに使う少し濃いめのグレー
          "info": "#3182CE",            // 情報カラーはブルー系でお知らせや通知に使用
          "success": "#48BB78",         // 成功メッセージは淡いグリーン系。成功時のフィードバック用
          "warning": "#ECC94B",         // 警告カラーは明るめのイエロー。注意が必要な要素に使用
          "error": "#F56565",           // エラーカラーは赤系。エラーメッセージやアイコンに使用
        },
      },
    ],
  },
}
