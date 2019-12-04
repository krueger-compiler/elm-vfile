module VFile.Core.VFileContents exposing (VFileContents, asString, decoder, encode, fromString)

import Json.Decode as JD exposing (Decoder)
import Json.Encode as JE exposing (Value)


type VFileContents
    = StringContents String


asString : VFileContents -> String
asString vFileContents =
    case vFileContents of
        StringContents text ->
            text


fromString : String -> VFileContents
fromString content =
    StringContents content


encode : VFileContents -> Value
encode (StringContents contents) =
    JE.string contents


decoder : Decoder VFileContents
decoder =
    stringContentsDecoder


stringContentsDecoder : Decoder VFileContents
stringContentsDecoder =
    JD.map StringContents JD.string
