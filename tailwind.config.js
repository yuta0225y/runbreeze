module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: { 
    },
  },
  plugins: [require("daisyui")],
  daisyui: {
    themes: [
      {
        mytheme: {
          "primary": "#00a8e8",
          "secondary": "#A0AEC0",
          "accent": "#ff9f1c",
          "neutral": "#E2E8F0",
          "base-100": "#FFFFFF",
          "base-200": "#F7FAFC",
          "base-300": "#EDF2F7",
          "info": "#3182CE",
          "success": "#48BB78",
          "warning": "#ECC94B",
          "error": "#F56565",
        },
      },
      // 他のテーマが必要な場合はここに追加
    ],
  },
}
