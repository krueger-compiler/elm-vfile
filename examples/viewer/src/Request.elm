module Request exposing (Request, RequestId, decoder, encode, requestId)

import Json.Decode as JD exposing (Decoder)
import Json.Encode as JE exposing (Value)


type RequestId
    = RequestId String


type alias Request a =
    { tag : String
    , requestId : RequestId
    , data : a
    }


requestId : String -> RequestId
requestId id =
    RequestId id


encode : (a -> Value) -> Request a -> Value
encode dataEncoder req =
    let
        (RequestId id) =
            req.requestId
    in
    JE.object
        [ ( "type", JE.string req.tag )
        , ( "requestId", JE.string id )
        , ( "data", dataEncoder req.data )
        ]


decoder : Decoder a -> Decoder (Request a)
decoder dataDecoder =
    JD.map3 Request
        (JD.field "type" JD.string)
        (JD.field "requestId" (JD.map RequestId JD.string))
        (JD.field "data" dataDecoder)
