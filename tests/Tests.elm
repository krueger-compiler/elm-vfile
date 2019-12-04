module Tests exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (..)
import Json.Decode as JD
import Json.Encode as JE
import String.UTF8 as UTF8
import Test exposing (Test, describe, fuzz, test)
import VFile
import VFile.Core.VFileContents as VFC


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
                    JD.decodeValue VFC.decoder json
                        |> Expect.equal (Ok (VFC.fromString contents))
            , fuzz string "It should be possible to decode when contents are a buffer" <|
                \text ->
                    let
                        bytes = UTF8.toBytes text
                        -- Create a JSON representation of the UTF8 Buffer content
                        jsonValue =
                            JE.object
                                [("type", JE.string "Buffer")
                                , ("data", JE.list JE.int bytes)
                                ]
                        
                        -- Decode the content from JSON
                        actual = JD.decodeValue VFC.decoder jsonValue

                        -- Extract the String
                        contentString =
                            actual
                            |> Result.mapError JD.errorToString
                            |> Result.andThen (\v -> VFC.toString v)                             
                    in                        
                        contentString
                        |> Expect.equal (Ok text)
                    
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
                            JD.decodeValue VFC.decoder json
                                |> Result.withDefault (VFC.fromString ("Decode Failed:" ++ contents))

                        encoded =
                            VFC.encode decoded
                    in
                    JE.encode 2 encoded
                        |> Expect.equal expected
            ]
        ]
