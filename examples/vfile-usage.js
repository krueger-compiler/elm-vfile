const vfile = require("vfile");
const toVFile = require("to-vfile");
const { resolve } = require("path");

const readMePath = resolve(__dirname, "../README.md");
const file = toVFile(resolve(readMePath));
console.log(file);

console.log("JSON: ", JSON.stringify(file, null, 2));

const stringVFile = vfile("Hello World");
console.log(stringVFile);

const overview = vfile({ path: "~/docs/overview.md", contents: "# Overview" });
console.log(overview);

overview.extname = ".markdown";
console.log(overview);
console.log(JSON.stringify(overview, null, 2));

const bufferSampleContents = "# Buffered";
const buffer = Buffer.from(bufferSampleContents, "utf8");
const bufferSample = vfile({
  path: "~/samples/buffered.markdown",
  contents: buffer
});
bufferSample.extname = ".md";

console.log(bufferSample);
console.log(JSON.stringify(bufferSample, null, 2));

const buffer16 = Buffer.from("# Buffer 16", "utf16le");
const buffer16Sample = vfile({
  path: "~/samples/buffered.markdown",
  contents: buffer16
});
buffer16Sample.extname = ".md";

console.log(buffer16Sample);
console.log(JSON.stringify(buffer16Sample, null, 2));
