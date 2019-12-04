module VFile exposing (VFile, decoder, encode)

import Json.Decode as JD exposing (Decoder, Value)
import VFile.Core.VFileProperties as VFP exposing (VFileProperties)


type VFile
    = VFile VFileProperties


encode : VFile -> Value
encode (VFile props) =
    VFP.encode props


decoder : Decoder VFile
decoder =
    JD.map VFile VFP.decoder
