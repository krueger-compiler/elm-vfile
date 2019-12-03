module VFile.Core.VFileProperties exposing (VFileProperties)

import VFile.Core.VFileContents exposing(VFileContents)
import Json.Encode as JE exposing (Value)
import Json.Decode as JD exposing (Decoder, field)
import Json.Decode.Extra exposing (andMap, optionalNullableField)

type alias VFileProperties =
    { cwd: List String 
    , separator: Char
    , contents: Maybe VFileContents
    }

type alias RawProperties =
    { cwd: String
    , contents: Maybe VFileContents
    }    

decoder : Decoder VFileProperties
decoder =
    Debug.todo "Implement this"

rawPropertiesDecoder : Decoder RawProperties
rawPropertiesDecoder =
    JD.succeed RawProperties
        |> andMap (field "cwd" JD.string)
        |> andMap (optionalNullableField "contents" )