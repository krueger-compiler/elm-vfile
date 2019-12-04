module VFile.Core.VFileContents exposing (VFileContents, decoder, encode, fromString, fromUTF8Bytes, toString, toStringOrDefault)

import Json.Decode as JD exposing (Decoder, field)
import Json.Decode.Extra exposing (when)
import Json.Encode as JE exposing (Value)
import String.UTF8 as UTF8


type VFileContents
    = StringContents String
    | UTF8BufferContents (List Int)


toString : VFileContents -> Result String String
toString vFileContents =
    case vFileContents of
        StringContents text ->
            Ok text

        UTF8BufferContents bytes ->
            UTF8.toString bytes


toStringOrDefault : String -> VFileContents -> String
toStringOrDefault defaultValue vFileContents =
    case vFileContents of
        StringContents text ->
            text

        UTF8BufferContents bytes ->
            UTF8.toString bytes |> Result.withDefault defaultValue


fromString : String -> VFileContents
fromString content =
    StringContents content


fromUTF8Bytes : List Int -> VFileContents
fromUTF8Bytes bytes =
    UTF8BufferContents bytes


encode : VFileContents -> Value
encode contents =
    case contents of
        StringContents text ->
            JE.string text

        UTF8BufferContents bytes ->
            JE.object
                [ ( "type", JE.string "Buffer" )
                , ( "data", JE.list JE.int bytes )
                ]


decoder : Decoder VFileContents
decoder =
    JD.oneOf
        [ utf8BufferContentsDecoder
        , stringContentsDecoder
        ]


stringContentsDecoder : Decoder VFileContents
stringContentsDecoder =
    JD.map StringContents JD.string


is : a -> a -> Bool
is a b =
    a == b


utf8BufferContentsDecoder : Decoder VFileContents
utf8BufferContentsDecoder =
    let
        contentType =
            field "type" JD.string

        utf8Buffer =
            JD.map UTF8BufferContents (field "data" (JD.list JD.int))
    in
    when contentType (is "Buffer") utf8Buffer
