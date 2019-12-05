module VFile.Core.Path exposing(FilePath, basename, defaultSeparator)

type alias FilePath = 
    { segments: List String
    , separator: Char 
    }

basename: FilePath -> Maybe String
basename {segments} =
    case segments of
       [] -> Nothing
       _ ->
        let
            reversedSegments = List.reverse segments
        in        
            case reversedSegments of
                end::_ -> Just end
                [] -> Nothing

defaultSeparator : Char
defaultSeparator = '/'