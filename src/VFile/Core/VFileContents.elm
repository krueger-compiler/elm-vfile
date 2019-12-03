module VFile.Core.VFileContents exposing (VFileContents, fromString)

type VFileContents 
    = StringContents String

fromString : String -> VFileContents    
fromString content = StringContents content