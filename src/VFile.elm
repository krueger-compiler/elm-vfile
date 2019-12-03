module VFile exposing(VFile, createFromPath)

import VFile.Core.VFileProperties exposing(VFileProperties)
import Json.Encode as JE exposing (Value)
import Json.Decode as JD exposing (Decoder)

type VFile 
    = VFile VFileProperties

createFromPath: String -> Char -> VFile
createFromPath path separator =
    let
        sep = String.fromChar separator
        pathSegments = String.split sep path
    in       
        { cwd = pathSegments
        , separator = separator
        , contents = Nothing
        } |> VFile       


decoder: Decoder VFile
decoder =
    JD.map3    