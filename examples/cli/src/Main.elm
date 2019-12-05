port module Main exposing (..)

import Json.Decode as JD exposing (Value)
import Json.Encode as JE
import Request
import VFile exposing (VFile)


type alias Flags =
    {}


type alias Model =
    {}


type Msg
    = Echo Value


port echo : (Value -> msg) -> Sub msg


port echoResponse : Value -> Cmd msg


main : Program Flags Model Msg
main =
    Platform.worker
        { init = init
        , update = update
        , subscriptions = subscriptions
        }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( flags, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Echo value ->
            let                
                req =
                    Debug.log "[elm:Echo value]" (JE.encode 0 value)

                decoded =
                    JD.decodeValue VFile.decoder value

                cwd =
                    decoded
                        |> Result.map VFile.cwd
                        |> Result.withDefault "N/A"
                        |> Debug.log "[elm:Echo:cwd]"

                contentType =
                    decoded
                        |> Result.map VFile.contentType
                        |> Debug.log "[elm:Echo:contentType]"

                contents =
                    decoded
                        |> Result.map VFile.contents
                        |> Debug.log "[elm:Echo:contents]"

                vfileEncoder =
                    \vfile ->
                        [ JE.null, VFile.encode vfile ]
                            |> JE.list identity

                errorEncoder =
                    \err ->
                        [ JD.errorToString err |> JE.string, JE.null ]
                            |> JE.list identity

                response =
                    encodeResult errorEncoder vfileEncoder decoded
            in
            ( model, echoResponse response )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ echo Echo ]


encodeResult : (e -> Value) -> (a -> Value) -> Result e a -> Value
encodeResult onError onOk res =
    case res of
        Ok value ->
            onOk value

        Err err ->
            onError err
