const vfile = require("vfile");
const toVFile = require("to-vfile");
const {resolve} = require("path");

const readMePath = resolve(__dirname, "../README.md");
const file = toVFile(resolve(readMePath));
console.log(file);

console.log('JSON: ', JSON.stringify(file,null, 2));

const stringVFile = vfile("Hello World");
console.log(stringVFile);