module Tests exposing (..)

import Test exposing(Test, describe,test)
import Expect exposing (Expectation)

vfileSuite: Test
vfileSuite =
    describe "VFile"
        [ describe "Given a path and separator"
            [ test "Can be created from a path and separator" <|
                \() ->
                    let
                        path = "root/parent/theFile.md"
                        separator = '/'
                        expected =  Cwd VFile 
                    in

                    
            ]
        ]

