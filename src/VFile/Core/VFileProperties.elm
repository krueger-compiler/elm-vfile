module VFile.Core.VFileProperties exposing (VFileProperties, decoder, encode)

import Json.Decode as JD exposing (Decoder, field, maybe)
import Json.Decode.Extra exposing (andMap, optionalField, optionalNullableField, withDefault)
import Json.Encode as JE exposing (Value)
import Json.Encode.Extra as JEE
import VFile.Core.VFileContents as VFC exposing (VFileContents)


type alias VFileProperties =
    { cwd : String
    , data : Value
    , history : List String
    , contents : Maybe VFileContents
    }


{-| Encode the properties of a VFile.
-}
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
    JD.map4 VFileProperties
        (field "cwd" JD.string)
        (field "data" JD.value |> withDefault JE.null)
        (field "history" (JD.list JD.string) |> withDefault [])
        (maybe (field "contents" VFC.decoder))
