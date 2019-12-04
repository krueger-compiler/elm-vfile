module VFile exposing (VFile, contents, contentsAsString, contentsToStringOrDefault,  decoder, encode)

import Json.Decode as JD exposing (Decoder, Value)
import VFile.Core.VFileContents as VFC exposing (VFileContents)
import VFile.Core.VFileProperties as VFP exposing (VFileProperties)

type VFile
    = VFile VFileProperties

contents : VFile -> Maybe VFileContents
contents (VFile file) =
    file.contents

contentsAsString : VFile -> Maybe String
contentsAsString (VFile file) =    
    let
        fn =         
            \fileContents ->
                case VFC.toString fileContents of
                    Ok text -> Just text
                    Err _ -> Nothing
    in    
        file.contents
        |> Maybe.andThen fn
                
contentsToStringOrDefault : String -> VFile -> String
contentsToStringOrDefault defaultValue (VFile file) =
    case file.contents of
        Just fileContents ->
            VFC.toStringOrDefault defaultValue fileContents               
        Nothing -> defaultValue

encode : VFile -> Value
encode (VFile props) =
    VFP.encode props

decoder : Decoder VFile
decoder =
    JD.map VFile VFP.decoder
