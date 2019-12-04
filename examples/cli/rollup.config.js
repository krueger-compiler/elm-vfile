import elm from "rollup-plugin-elm";

export default [
  {
    input: "./src/index.js",
    output: {
      file: `dist/app.js`,
      format: "cjs"
    },
    plugins: [
      elm({
        exclude: "elm_stuff/**"
      })
    ]
  }
];
