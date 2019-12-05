import Elm from "./Main.elm";
import globby from "globby";
import vfile from "to-vfile";
import { promisify } from "util";
import { codeFrameColumns } from "@babel/code-frame";
import uuid from "uuid/v1";
const readVFileAsync = promisify(vfile.read);

const app = Elm.Main.init({});

console.dir(app);

(async () => {
  const paths = await globby([
    "**/*.md",
    "!package-lock.json",
    "!node_modules",
    "!elm-stuff",
    "!dist"
  ]);

  console.log(paths);
  console.log("********************************");
  for (const path of paths) {
    const file = await readVFileAsync(path);
    console.log(
      "--------------------------------------------------------------"
    );
    console.log("File: ", file.path);

    await echo(file);
    //printCode(file);

    //console.log(JSON.stringify(file, null, 2));
  }
})();

function echo(file) {
  return new Promise((resolve, reject) => {
    const requestId = uuid();
    file.data.requestId = requestId;
    const handler = response => {
      const [err, result] = response;
      if (err) {
        console.error(err);
        return reject(new Error(err));
      } else {
        printCode(result);
        return resolve(result);
      }
    };
    app.ports.echoResponse.subscribe(handler);
    app.ports.echo.send(file);
  });
}

function printCode(file) {
  const fileContents = file.toString();
  const lines = fileContents.split("\n");
  const location = {
    start: { line: 1 }
  };
  const code = codeFrameColumns(fileContents, location, {
    linesBelow: lines.length - 1
  });
  console.log(code);
}
