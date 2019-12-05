module VFile exposing (VFile, contentType, contents, contentsAsString, contentsToStringOrDefault, cwd, decoder, encode)

import Json.Decode as JD exposing (Decoder, Value)
import VFile.Core.VFileContents as VFC exposing (VFileContents)
import VFile.Core.VFileProperties as VFP exposing (VFileProperties)


type VFile
    = VFile VFileProperties


contents : VFile -> Maybe VFileContents
contents (VFile file) =
    file.contents


contentType : VFile -> String
contentType (VFile props) =
    case props.contents of
        Just fileContents ->
            VFC.contentType fileContents

        Nothing ->
            "null"


contentsAsString : VFile -> Maybe String
contentsAsString (VFile file) =
    let
        fn =
            \fileContents ->
                case VFC.toString fileContents of
                    Ok text ->
                        Just text

                    Err _ ->
                        Nothing
    in
    file.contents
        |> Maybe.andThen fn


contentsToStringOrDefault : String -> VFile -> String
contentsToStringOrDefault defaultValue (VFile file) =
    case file.contents of
        Just fileContents ->
            VFC.toStringOrDefault defaultValue fileContents

        Nothing ->
            defaultValue

cwd: VFile -> String
cwd (VFile props) =
    props.cwd

encode : VFile -> Value
encode (VFile props) =
    VFP.encode props


decoder : Decoder VFile
decoder =
    JD.map VFile VFP.decoder
