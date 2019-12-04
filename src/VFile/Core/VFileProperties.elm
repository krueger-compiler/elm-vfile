module VFile.Core.VFileProperties exposing (VFileProperties, decoder, encode)

import Json.Decode as JD exposing (Decoder, field)
import Json.Decode.Extra exposing (andMap, optionalNullableField, withDefault)
import Json.Encode as JE exposing (Value)
import Json.Encode.Extra as JEE
import VFile.Core.VFileContents as VFC exposing (VFileContents)


type alias VFileProperties =
    { cwd : String
    , contents : Maybe VFileContents
    , data : Value
    , history : List String
    }


encode : VFileProperties -> Value
encode { cwd, contents, data, history } =
    JE.object
        [ ( "cwd", JE.string cwd )
        , ( "contents", JEE.maybe VFC.encode contents )
        , ( "data", data )
        , ( "history", JE.list JE.string history )
        ]

decoder : Decoder VFileProperties
decoder =
    JD.succeed VFileProperties
        |> andMap (field "cwd" JD.string)
        |> andMap (optionalNullableField "contents" VFC.decoder)
        |> andMap (field "data" JD.value |> withDefault JE.null)
        |> andMap (field "history" (JD.list JD.string) |> withDefault [])
