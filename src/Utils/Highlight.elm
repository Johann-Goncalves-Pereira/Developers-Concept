module Utils.Highlight exposing (..)

import Html exposing (Html, code, text)
import Parser exposing (DeadEnd)
import String exposing (join)
import SyntaxHighlight exposing (HCode, toBlockHtml)


codeHighlight : (String -> Result (List DeadEnd) HCode) -> String -> Html msg
codeHighlight lang str =
    lang
        str
        |> Result.map (toBlockHtml (Just 0))
        |> Result.withDefault
            (code [] [ text "isEmpty : String -> Bool" ])


codeFormatter : List String -> String
codeFormatter formation =
    join "\n" formation
