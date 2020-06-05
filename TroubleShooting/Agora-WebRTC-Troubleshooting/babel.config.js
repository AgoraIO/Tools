module.exports = {
  "presets": [
    [
      "@vue/app",
      {
        "useBuiltIns": "entry"
      },
      "@babel/preset-env",
    ]
  ],
  "plugins": [
    "@babel/plugin-proposal-export-namespace-from"
  ]
}