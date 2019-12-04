module VFile.Core.VFileContents exposing (VFileContents, toString, toStringOrDefault, decoder, encode, fromString, fromUTF8Bytes)

import Json.Decode as JD exposing (Decoder, field)
import Json.Decode.Extra exposing(when)
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
                [("type", JE.string "Buffer")
                , ("data", JE.list JE.int bytes)]


decoder : Decoder VFileContents
decoder =
    JD.oneOf 
        [stringContentsDecoder
        , utf8BufferContentsDecoder
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
        bufferDecoder = 
            field "data" (JD.list JD.int)
            |> when (field "type" JD.string) (is "Buffer" )    
    in
        JD.map UTF8BufferContents bufferDecoder

