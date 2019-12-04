import Elm from "./Main.elm";
import globby from "globby";
import vfile from "to-vfile";
import { promisify } from "util";
import { codeFrameColumns } from "@babel/code-frame";

const readVFileAsync = promisify(vfile.read);

const app = Elm.Main.init({});

console.dir(app);

(async () => {
  const paths = await globby([
    "**",
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

    const fileContents = file.toString();
    const lines = fileContents.split("\n");
    const location = {
      start: { line: 1 }
    };
    const code = codeFrameColumns(fileContents, location, {
      linesBelow: lines.length - 1
    });
    console.log(code);

    console.log(JSON.stringify(file, null, 2));
  }
})();
