module VFile exposing (VFile, contents, contentsAsString, decoder, encode)

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
    Maybe.map VFC.asString file.contents


encode : VFile -> Value
encode (VFile props) =
    VFP.encode props


decoder : Decoder VFile
decoder =
    JD.map VFile VFP.decoder
