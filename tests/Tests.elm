module Tests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (..)
import Json.Decode as JD
import Json.Encode as JE
import Test exposing (Test, describe, fuzz, test)
import VFile
import VFile.Core.VFileContents


vfileSuite : Test
vfileSuite =
    describe "VFile"
        [ describe "Decoding"
            [ test "A vfile can be decoded from JSON" <|
                \() ->
                    let
                        jsonValue =
                            JE.object
                                [ ( "cwd", JE.string "/root/docs" )
                                , ( "history", JE.list JE.string [ "~/docs/ReadMe.md" ] )
                                ]
                    in
                    JD.decodeValue VFile.decoder jsonValue
                        |> Expect.ok
            , test "The cwd field is required for decoding" <|
                \() ->
                    let
                        jsonValue =
                            JE.object
                                [ ( "data", JE.object [] ) ]
                    in
                    JD.decodeValue VFile.decoder jsonValue
                        |> Expect.err
            , test "The cwd field must be non-null for decoding to succeed" <|
                \() ->
                    let
                        jsonValue =
                            JE.object
                                [ ( "cwd", JE.null )
                                , ( "data", JE.object [] )
                                ]
                    in
                    JD.decodeValue VFile.decoder jsonValue
                        |> Expect.err
            ]
        ]


vFileContentsSuite : Test
vFileContentsSuite =
    describe "VFileContents"
        [ describe "Decoding"
            [ fuzz string "It should be possible to decode from a string" <|
                \contents ->
                    let
                        json =
                            JE.string contents
                    in
                    JD.decodeValue VFile.Core.VFileContents.decoder json
                        |> Expect.equal (Ok (VFile.Core.VFileContents.fromString contents))
            ]
        , describe "Codec"
            [ fuzz string "Decoding and encoding should yield the original JSON value" <|
                \contents ->
                    let
                        json =
                            JE.string contents

                        expected =
                            JE.encode 2 json

                        decoded =
                            JD.decodeValue VFile.Core.VFileContents.decoder json
                                |> Result.withDefault (VFile.Core.VFileContents.fromString ("Decode Failed:" ++ contents))

                        encoded =
                            VFile.Core.VFileContents.encode decoded
                    in
                    JE.encode 2 encoded
                        |> Expect.equal expected
            ]
        ]
